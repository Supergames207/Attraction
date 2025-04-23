extends Node3D

@export var SENS_X = 4.
@export var SENS_Y = 8.

@onready var Y_rot = $Y_rotation

var CameraDirection = Vector3.ZERO

func _unhandled_input(e: InputEvent) -> void:
	if e is not InputEventMouseMotion: return
	var event: InputEventMouseMotion = e
	
	CameraDirection.x -= event.relative.x * SENS_X / 100.
	CameraDirection.y -= event.relative.y * SENS_Y / 100.

func _process(_delta: float) -> void:
	rotation_degrees.y = CameraDirection.x

	Y_rot.rotation_degrees.x = CameraDirection.y
