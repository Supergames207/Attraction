@tool
class_name HealthComponent extends BaseComponent

func get_custom_class_name()->String:
	return "HealthComponent"

@export var max_health := 100.0
@export var resistance := 0.1

var cur_health := max_health

func _init() -> void:
	cur_health = max_health

func _ready() -> void:
	parent.physics_frame.connect(_physics_process)

func _physics_process(_delta:float) -> void:
	var colliding_bodies := parent.get_colliding_bodies()
	for bodie in colliding_bodies:
		if not bodie is RigidBody3D: continue
		var rigid :RigidBody3D = bodie

		var rigid_relative_pos := (parent.global_position-rigid.global_position).normalized()
		var rigid_relative_velocity := (rigid.linear_velocity*rigid.linear_velocity.dot(rigid_relative_pos)).length()
		rigid_relative_pos *= resistance

		var relative_pos := (rigid.global_position-parent.global_position).normalized()
		var relative_velocity := (parent.linear_velocity*parent.linear_velocity.dot(relative_pos)).length()
		relative_velocity *= resistance

		print("RIGID ",rigid_relative_pos,"\n CREATURE ",relative_velocity)
		change_health(-max(0,rigid_relative_velocity+relative_velocity))
		print(cur_health)

func change_health(change:int)->void:
	cur_health += change
	if cur_health>max_health: 
		cur_health = max_health
	if cur_health<0:
		die()


func die()->void:
	parent.queue_free()