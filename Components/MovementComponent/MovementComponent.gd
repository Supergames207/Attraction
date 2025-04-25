@tool
class_name MovementComponent extends BaseComponent

func get_custom_class_name()->String:
	return "MovementComponent"

@export var speed := 20
@export var rotation_speed := 20

var gravity :Vector3= ProjectSettings.get_setting("physics/3d/default_gravity_vector")
var Pid := Pid3D.new(20.0,5,0.2)

##Orients parent to a direction
func orient_parent_to_direction(direction:Vector3,delta:float) -> void:
	var left_axis :Vector3= -gravity.normalized().cross(direction.normalized())
	if left_axis == Vector3.ZERO:
		return
	
	var rotation_basis := Basis(left_axis,-gravity.normalized(),direction).orthonormalized()
	parent.transform.basis = Basis(parent.transform.basis.get_rotation_quaternion().slerp(rotation_basis,delta*rotation_speed))


func move(target_velocity:Vector3,delta:float)->void:
	target_velocity *= speed
	var velocity_error :Vector3 = target_velocity-parent.linear_velocity
	var force := Pid.update(velocity_error,delta)
	parent.apply_central_force(force)