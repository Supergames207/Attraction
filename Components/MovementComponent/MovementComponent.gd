@tool
class_name MovementComponent extends BaseComponent

func get_custom_class_name()->String:
	return "MovementComponent"

@export var speed := 6
@export var rotation_speed := 20
@export var gravity :Vector3= ProjectSettings.get_setting("physics/3d/default_gravity_vector")

@export var orient_body_to_direction := true

var Pid := Pid3D.new(2.0,0.2,0.)

##Orients parent to a direction
func orient_parent_to_direction(direction:Vector3,delta:float) -> void:
	var left_axis :Vector3= -gravity.normalized().cross(direction.normalized())
	if left_axis == Vector3.ZERO:
		return
	
	var rotation_basis := Basis(left_axis,-gravity.normalized(),direction).orthonormalized()
	parent.transform.basis = Basis(parent.transform.basis.get_rotation_quaternion().slerp(rotation_basis,delta*rotation_speed))


func move(target_velocity:Vector3,delta:float)->void:
	if target_velocity.length() < 1: Pid._p = 5
	else: Pid._p = 2
	target_velocity *= speed
	target_velocity += parent.basis.y.dot(parent.linear_velocity)*parent.basis.y
	var velocity_error :Vector3 = target_velocity-parent.linear_velocity
	var force := Pid.update(velocity_error,delta)
	#parent.apply_central_impulse(force*0.01)
	parent.apply_central_force(force)
	if parent.linear_velocity.length()<0.25: 
		parent.linear_velocity = Vector3.ZERO
	if orient_body_to_direction:
		orient_parent_to_direction(target_velocity,delta)
