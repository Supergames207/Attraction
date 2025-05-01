extends Control
@onready var player := owner.get_node("Player")

func _process(_delta:float)->void:
	$GridContainer/Position.text = "Position: "+str(player.global_position)
	$GridContainer/Velocity.text = "Velocity: "+str(player.linear_velocity)
	 
###################
## PRESS R TO RESET
###################

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
