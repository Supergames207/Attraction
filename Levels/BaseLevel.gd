@tool
class_name BaseLevel extends Node3D

@export var enemies_holder :Node3D
@export var buttons_holder :Node3D

signal changed
signal finished

func _ready() -> void:
	changed.connect(update)
	update()
	
func update() -> void:
	var level_finsihed :bool = len(enemies_holder.get_children())==0
	
	if not level_finsihed: return
	print(self.name)
	for button:DoorButton in buttons_holder.get_children():
		if button.active: continue
		level_finsihed = false
	finished.emit(level_finsihed)
	if level_finsihed:
		print(self.name," Level Finished")
