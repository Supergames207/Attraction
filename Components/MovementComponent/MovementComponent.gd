@tool
extends BaseComponent
class_name MovementComponent

func get_custom_class_name()->String:
	return "MovementComponent"

@export var rotation_speed := 20

var gravity :Vector3= ProjectSettings.get_setting("physics/3d/default_gravity_vector")
var Pid := Pid3D.new(1.0,0.1,1.0)

##Orients body to a direction
func orient_body_to_direction(body:RigidBody3D,direction:Vector3,delta:float) -> void:
	var left_axis :Vector3= -gravity.normalized().cross(direction.normalized())
	if left_axis == Vector3.ZERO:
		return
	
	var rotation_basis := Basis(left_axis,-gravity.normalized(),direction).orthonormalized()
	body.transform.basis = Basis(body.transform.basis.get_rotation_quaternion().slerp(rotation_basis,delta*rotation_speed))


func move(body:RigidBody3D,target_velocity:Vector3,delta:float)->void:
	var velocity_error := target_velocity-body.linear_velocity
	var impulse := Pid.update(velocity_error,delta)*0.005
	body.apply_central_impulse(impulse)