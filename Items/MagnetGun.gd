extends Node3D
var pull := false
var on := false
var magnet_power := 0.2

func _input(e:InputEvent)->void:
	if not e is InputEventMouseButton:return
	var event:InputEventMouseButton = e
	if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		on = not on


func _physics_process(_delta:float)->void:
	for rigid:Node3D in $MagnetReach.get_overlapping_bodies():
		if not rigid is RigidBody3D:continue
		var error :Vector3= global_position-rigid.global_position
		rigid.apply_central_impulse(error*magnet_power*1/error.length())
