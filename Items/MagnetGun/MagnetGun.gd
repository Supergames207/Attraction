extends Node3D


@onready var magnet_area: Area3D = $MagnetArea
@onready var gun_front: Node3D = %GunFront

@export var magnet_power := 20
var pulling := 0.0


func _physics_process(delta: float) -> void:
	pulling = Input.get_axis("magnet_push", "magnet_pull")
	apply_object_force(delta)


func apply_object_force(delta: float) -> void:
	var bodies: Array[Node3D] = magnet_area.get_overlapping_bodies()
	owner.components["MovementComponent"].gravity = Vector3.ZERO
	for i: Node3D in bodies:
		if not i.is_in_group("Metal"): continue

		var pull_dampening := 0.7
		var push_dampening := 0.8

		if i is RigidBody3D:
			var displacement := gun_front.global_position - i.global_position
			var acceleration := displacement.normalized() * ((magnet_power*7) / displacement.length())
			
			var rb: RigidBody3D = i
			rb.apply_central_force(pulling*acceleration)
			#rb.linear_velocity += pulling * acceleration * delta * 60
			#if pulling > 0:
			#	rb.linear_velocity *= pull_dampening
			#elif pulling < 0:
			#	rb.linear_velocity *= push_dampening
		elif i is StaticBody3D:
			pulling = -pulling
			var r := cast_raycast(owner.global_position,i.global_position)
			var displacement :Vector3= i.global_position-owner.global_position

			if r and cast_raycast(owner.global_position,owner.global_position-r["normal"]*displacement.length()):

				var result := cast_raycast(owner.global_position,owner.global_position-r["normal"]*displacement.length())
				var dp :Vector3 = result["position"]-owner.global_position
				var power := (magnet_power) / (dp.length())
				var acceleration :Vector3= pulling * -r["normal"] * power
				owner.components["MovementComponent"].gravity += acceleration
			else: #In case we can't get the surface normal
				var power := magnet_power / (displacement.length())
				var acceleration := pulling * displacement.normalized() * power
				owner.components["MovementComponent"].gravity += acceleration
			
			pulling = -pulling
	if owner.components["MovementComponent"].gravity == Vector3.ZERO or pulling==0:
		owner.components["MovementComponent"].gravity = Vector3(0,-9.8,0)

func cast_raycast(origin:Vector3,end:Vector3)->Dictionary:
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(origin, end)
	query.exclude = [self]
	var result := space_state.intersect_ray(query)
	return result

func unequip() -> void:
	owner.components["MovementComponent"].gravity = Vector3(0,-9.8,0)