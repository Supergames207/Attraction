@tool
class_name BaseLevel extends Node3D

@export var enemies_holder :Node3D
@export var buttons_holder :Node3D

signal changed


func _ready() -> void:
    changed.connect(update)
    
func update() -> void:
    var level_finsihed :bool = len(enemies_holder.get_children())==0
    
    if not level_finsihed: return

    for button:DoorButton in buttons_holder.get_children():
        if button.active: continue
        level_finsihed = false

    if level_finsihed:
        finish_level()
    
func finish_level() -> void:
    print("Level Finished")