class_name MetalWall extends MeshInstance3D

func _ready() -> void:
    create_convex_collision()
    for child in get_children():
        if not child is StaticBody3D: return
        var s :StaticBody3D = child
        s.set_collision_layer_value(2,true)
        s.set_collision_mask_value(2,true)
        s.add_to_group("Metal")