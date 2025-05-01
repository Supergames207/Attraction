extends Node3D

@export var magnet_power := 4
var pulling := 0.0


@onready var magnet_area: Area3D = $MagnetArea
@onready var gun_front: Node3D = $GunFront

func _input(e:InputEvent)->void:
	if not e is InputEventKey: return

	var event:InputEventKey = e
	if event.pressed and event.keycode == KEY_E:
		pulling = not pulling

func _physics_process(delta: float) -> void:
	pulling = Input.get_axis("magnet_push", "magnet_pull")
	apply_object_force(delta)

func apply_object_force(delta: float) -> void:
	if not pulling: return
	var bodies: Array[Node3D] = magnet_area.get_overlapping_bodies()
	
	for i: Node3D in bodies:
		if not i.is_in_group("Metal"): continue
		if i is RigidBody3D:
			var displacement := gun_front.global_position - i.global_position
			var acceleration := displacement * magnet_power / displacement.length()
			var pull_dampening := 0.7
			var push_dampening := 0.8
			
			var rb: RigidBody3D = i
			rb.linear_velocity += pulling * acceleration * delta * 60
			
			if pulling > 0:
				rb.linear_velocity *= pull_dampening
			else:
				rb.linear_velocity *= push_dampening