extends Node3D

@export var SENS_X := 6.
@export var SENS_Y := 10.

@onready var Y_rot := $Y_rotation

var CameraDirection := Vector3.ZERO

func _unhandled_input(e: InputEvent) -> void:
	if e is not InputEventMouseMotion or Input.mouse_mode != Input.MOUSE_MODE_CAPTURED: return
	var event: InputEventMouseMotion = e
	
	CameraDirection.x -= event.relative.x * SENS_X / 100.
	CameraDirection.y -= event.relative.y * SENS_Y / 100.
	CameraDirection.y = clamp(CameraDirection.y,-80,80)
	rotate_object_local(Vector3.UP,deg_to_rad(-event.relative.x * SENS_X / 100.))
	Y_rot.rotation_degrees.x = CameraDirection.y

func _process(delta: float) -> void:
	global_position = owner.global_position+owner.global_basis.y*0.5
	orient_body_to_direction(global_basis.z,delta)

func orient_body_to_direction(direction:Vector3,delta:float) -> void:
	var left_axis :Vector3= -get_parent().components["MovementComponent"].gravity.normalized().cross(direction.normalized())
	if left_axis == Vector3.ZERO:
		return
	var rotation_speed := 20
	var rotation_basis := Basis(left_axis,-get_parent().components["MovementComponent"].gravity.normalized(),direction).orthonormalized()
	transform.basis = Basis(transform.basis.get_rotation_quaternion().slerp(rotation_basis,delta*rotation_speed))
