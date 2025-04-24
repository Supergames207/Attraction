extends Node3D

@export var magnet_power := 4
var pulling := false

@onready var magnet_area: Area3D = $MagnetArea
@onready var gun_front: Node3D = $GunFront

func _physics_process(delta: float) -> void:
	pulling = Input.is_action_pressed("magnet_pull")
	pull_objects(delta)

func pull_objects(delta: float):
	if not pulling: return
	var bodies = magnet_area.get_overlapping_bodies()
	
	for i: Node3D in bodies:
		if i.name == "Player": continue
		if i is not RigidBody3D: continue
		
		var displacement = gun_front.global_position - i.global_position
		var acceleration = displacement * magnet_power / displacement.length()
		var dampening = 0.7
		
		var rb: RigidBody3D = i
		rb.linear_velocity += acceleration * delta * 60
		rb.linear_velocity *= dampening
