@tool
class_name MovementComponent extends BaseComponent

func get_custom_class_name()->String:
	return "MovementComponent"

@export var speed := 6
@export var jump_power := 10
@export var rotation_speed := 20
@export var default_gravity := Vector3(0,-9.8,0)
@export var gravity := Vector3(0,-9.8,0)


@export var orient_body_to_direction := true

var Pid := Pid3D.new(2.0,0.2,0.)
var jump_debounce := false
var last_strong_dir := Vector3.ZERO

##Orients parent to a direction
func orient_parent_to_direction(direction:Vector3,delta:float) -> void:
	var left_axis :Vector3= -gravity.normalized().cross(direction.normalized())
	if left_axis == Vector3.ZERO:
		return
	
	var rotation_basis := Basis(left_axis,-gravity.normalized(),direction).orthonormalized()
	parent.transform.basis = Basis(parent.transform.basis.get_rotation_quaternion().slerp(rotation_basis,delta*rotation_speed))

##Applies a force to self's parent for it to achieve target_velocity
func move(target_velocity:Vector3,delta:float)->void:
	if Engine.is_editor_hint(): return
	if target_velocity.length()>0.2:
		last_strong_dir = target_velocity
	target_velocity *= speed
	target_velocity += parent.basis.y.dot(parent.linear_velocity)*parent.basis.y
	var velocity_error :Vector3 = target_velocity-parent.linear_velocity
	var force := Pid.update(velocity_error,delta)
	parent.apply_central_force(gravity+force)
	#if parent.linear_velocity.length()<0.25 and cast_raycast(parent.global_position,parent.global_position-parent.basis.y*1.1) and jump_debounce: 
	#	parent.linear_velocity = Vector3.ZERO
	if not jump_debounce: jump_debounce = true
	if orient_body_to_direction:
		orient_parent_to_direction(last_strong_dir,delta)


##Jumps, isn't it obvious?
func jump() -> void:
	if not cast_raycast(parent.global_position,parent.global_position-parent.basis.y*1.5): return
	jump_debounce = false
	parent.apply_central_impulse(parent.basis.y*jump_power)

func cast_raycast(origin:Vector3,end:Vector3)->Dictionary:
	var space_state: PhysicsDirectSpaceState3D = parent.get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(origin, end)
	query.exclude = [self]
	var result := space_state.intersect_ray(query)
	return result
