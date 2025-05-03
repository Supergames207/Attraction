class_name DoorButton extends StaticBody3D

##If false after one collision it's going to be always active
@export var collision_needed := true

var active := false

@onready var hitbox := %HitBox

func _ready() -> void:
    hitbox.body_entered.connect(body_entered)
    hitbox.body_exited.connect(body_exited)

func _process(delta:float) -> void:
    if not active:
        %Active.position = lerp(%Active.position,Vector3(0,0.125,0),delta*2)
    else:
         %Active.position = lerp(%Active.position,Vector3.ZERO,delta*2)

func body_entered(_body:Node) -> void:
    print(_body)
    if not collision_needed and active: return
    active = len(hitbox.get_overlapping_bodies()) > 1
    %Active.get_node("StaticBody3D/CollisionShape3D").set_deferred("disbled",active)
    owner.changed.emit()

func body_exited(_body:Node) -> void:
    print(_body)
    if not collision_needed and active: return
    active = len(hitbox.get_overlapping_bodies()) > 1
    %Active.get_node("StaticBody3D/CollisionShape3D").set_deferred("disbled",active)
    owner.changed.emit()