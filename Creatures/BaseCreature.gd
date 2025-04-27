@tool
class_name BaseCreature extends RigidBody3D

@export var components : Dictionary[String,BaseComponent]:
	set(value):
		for key:String in value.keys():
			if not "get_custom_class_name" in value[key] or value[key].get_custom_class_name() == key: continue
			#Replace the key for the custom class name
			value[value[key].get_custom_class_name()] = value[key]
			value.erase(key)
		
		components = value

signal physics_frame
signal process_frame


func _ready()->void:
	for component:BaseComponent in components.values():
		component.parent = self
		if "_ready" in component:
			component.call("_ready")
	

func _physics_process(delta:float)->void:
	physics_frame.emit(delta)

func _process(delta:float)->void:
	process_frame.emit(delta)
