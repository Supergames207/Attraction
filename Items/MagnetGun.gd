extends Node3D
var pull := false
var magnet_power := 20

func _input(e:InputEvent)->void:
	if e is InputEventMouseButton:
		var event:InputEventMouseButton = e
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			pull = not pull
	elif e is InputEventKey:
		var event:InputEventKey= e
		if e.pressed and event.keycode == KEY_R:
			$MagnetReach.monitoring = not $MagnetReach.monitoring


func _physics_process(_delta:float)->void:
	if not $MagnetReach.monitoring: return
	for rigid:Node3D in $MagnetReach.get_overlapping_bodies():
		if not rigid is RigidBody3D:continue
		if rigid.name == "Enemy": continue
		var pos_error :Vector3= global_position-rigid.global_position
		#rigid.apply_central_impulse(error*magnet_power/(error.length()*error.length()))
		var length := pos_error.length() / 2
		#var upwards := Vector3.UP * 0.2
		rigid.apply_central_force(pos_error * magnet_power / (length*length)*(int(pull)*2-1))# + upwards)
