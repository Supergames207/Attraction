@tool
extends RigidBody3D
class_name BaseCreature

@export var components :Dictionary[String,BaseComponent]:
	set(value):
		for key:String in value.keys():
			if not "get_custom_class_name" in value[key] or value[key].get_custom_class_name() == key: continue
			#Replace the key for the custom class name
			value[value[key].get_custom_class_name()] = value[key]
			value.erase(key)
		
		components = value
