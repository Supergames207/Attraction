@tool
extends BaseComponent
class_name HealthComponent

func get_custom_class_name()->String:
    return "HealthComponent"

@export var max_health := 100

var cur_health := max_health

func _init()->void:
    cur_health = max_health

func change_health(change:int)->void:
    cur_health += change
    if cur_health>max_health: 
        cur_health = max_health
    if cur_health<0:
        die()

func die()->void:
    pass
