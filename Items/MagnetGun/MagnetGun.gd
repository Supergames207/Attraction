extends Node3D

@export var magnet_power := 4
var enabled := false
var pulling := false

@onready var magnet_area: Area3D = $MagnetArea
@onready var gun_front: Node3D = $GunFront

func _input(e:InputEvent)->void:
	if not e is InputEventKey: return

	var event:InputEventKey = e
	if event.pressed and event.keycode == KEY_E:
		pulling = not pulling

func _physics_process(delta: float) -> void:
	enabled = Input.is_action_pressed("magnet_enable")
	pull_objects(delta)

func pull_objects(delta: float)->void:
	if not enabled: return
	var bodies := magnet_area.get_overlapping_bodies()
	
	for i: Node3D in bodies:
		if i.name == "Player": continue
		if i is not RigidBody3D: continue
		
		var displacement := gun_front.global_position - i.global_position
		var acceleration := (displacement * magnet_power / (displacement.length()**2)) * (int(pulling)*2-1)
		var dampening := 0.7
		
		var rb: RigidBody3D = i

		#rb.apply_central_force(acceleration*12)

		rb.linear_velocity += acceleration * delta * 60
		rb.linear_velocity *= dampening
