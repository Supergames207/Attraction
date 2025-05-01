extends Node3D

@export var magnet_power := 20
var pulling := 0.0


@onready var magnet_area: Area3D = $MagnetArea
@onready var gun_front: Node3D = $GunFront

func _input(e:InputEvent)->void:
	if not e is InputEventKey: return

	#What?
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

		var pull_dampening := 0.7
		var push_dampening := 0.8

		if i is RigidBody3D:
			var displacement := gun_front.global_position - i.global_position
			var acceleration := displacement.normalized() * magnet_power / displacement.length()
			
			var rb: RigidBody3D = i
			rb.linear_velocity += pulling * acceleration * delta * 60
			
			if pulling > 0:
				rb.linear_velocity *= pull_dampening
			else:
				rb.linear_velocity *= push_dampening
		elif i is StaticBody3D:
			#TODO invert pulling here
			pulling = -pulling
			var r := cast_raycast(owner.global_position,i.global_position)
			var displacement :Vector3= i.global_position-owner.global_position

			if r and cast_raycast(owner.global_position,owner.global_position-r["normal"]*displacement.length()):

				var result := cast_raycast(owner.global_position,owner.global_position-r["normal"]*displacement.length())
				var dp :Vector3 = result["position"]-owner.global_position
				var power := (magnet_power*10) / (dp.length())
				owner.apply_central_force(pulling * -r["normal"] * power)
			else: #In case we can't get the surface normal
				var power := magnet_power / (displacement.length())
				var acceleration := pulling * displacement.normalized() * power
				owner.apply_central_force(acceleration)
				
			pulling = -pulling

func cast_raycast(origin:Vector3,end:Vector3)->Dictionary:
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(origin, end)
	query.exclude = [self]
	var result := space_state.intersect_ray(query)
	return result
