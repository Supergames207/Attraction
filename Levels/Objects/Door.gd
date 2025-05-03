@tool
class_name Door extends CSGBox3D

@export var closed :bool:
    set(value):
        $Door.visible = value
        $Door/StaticBody3D/CollisionShape3D.set_deferred("disabled",not value)
        closed = value

func _ready() -> void:
    owner.finished.connect(open)

func open(level_finsihed:bool) -> void:
    closed = not level_finsihed