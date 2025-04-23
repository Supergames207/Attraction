extends Node3D
class_name InventoryManagement
var slot_equipped:int = -1
var inventory_data := load("res://UI/Inventory/InventoryData.tres")

func _input(e:InputEvent)->void:
	if not e is InputEventKey: return
	var event:InputEventKey = e
	if event.pressed and event.keycode>KEY_0 and event.keycode<=KEY_9:
		if event.keycode-48-1!=slot_equipped: slot_equipped = event.keycode-48-1#since it's a list we subtract minus 1
		else: slot_equipped = -1
		load_item()

func load_item()->void:
	for child in get_children():
		child.queue_free()
	if slot_equipped<0 or not inventory_data.slotdatas[slot_equipped] or not inventory_data.slotdatas[slot_equipped].item or not inventory_data.slotdatas[slot_equipped].item.scene:return
	var new_item :Node= inventory_data.slotdatas[slot_equipped].item.scene.instantiate()
	add_child(new_item)
