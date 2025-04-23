extends Control
@onready var player := owner.get_node("Player")

func _process(_delta:float)->void:
    $GridContainer/Position.text = "Position: "+str(player.global_position)
    $GridContainer/Velocity.text = "Velocity: "+str(player.velocity)
     
