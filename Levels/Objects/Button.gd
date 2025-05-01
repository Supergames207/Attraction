class_name DoorButton extends StaticBody3D

var active := false
var hitbox := Area3D.new()

func _ready() -> void:
    var col_shape := CollisionShape3D.new()
    col_shape.shape = BoxShape3D.new()
    col_shape.shape.size = Vector3(1,1,1)

    add_child(hitbox)
    hitbox.add_child(col_shape)

    hitbox.body_entered.connect(body_entered)
    hitbox.body_exited.connect(body_exited)


func body_entered() -> void:
    active = len(hitbox.get_overlapping_bodies()) > 0
    owner.changed.emit()

func body_exited() -> void:
    active = len(hitbox.get_overlapping_bodies()) > 0
    owner.changed.emit()