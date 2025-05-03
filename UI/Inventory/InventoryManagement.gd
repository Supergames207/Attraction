extends Node3D
class_name InventoryManagement

@export var default_position: Vector3 = Vector3(0.75, -0.5, -0.75)

@onready var camera_3d: Camera3D = %Camera3D
@onready var slot_container: HBoxContainer = get_root().get_node("%S_Inventory/%SlotContainer")

var current_slot: PanelContainer = null
var slot_equipped: int = -1
var inventory_data := load("res://UI/Inventory/InventoryData.tres")
var slot_themes: Dictionary[String, Theme] = {
	default = preload("res://UI/Inventory/Themes/slot_default.tres"),
	equipped = preload("res://UI/Inventory/Themes/slot_equipped.tres"),
}

func _input(e: InputEvent) -> void:
	if not e is InputEventKey: return
	var event: InputEventKey = e

	if event.pressed and event.keycode > KEY_0 and event.keycode <= KEY_9:
		if event.keycode - 48 - 1 != slot_equipped:
			slot_equipped = event.keycode - 48 - 1 # Subtract 1 due to list
		else:
			slot_equipped = -1
		
		load_item()
		update_slot()

func get_root() -> Node:
	return get_tree().root.get_child(0)

func load_item() -> void:
	for child in camera_3d.get_children():
		if "unequip" in child:
			child.call("unequip")
		child.queue_free()
	
	if (slot_equipped < 0
		or not inventory_data.slotdatas[slot_equipped]
		or not inventory_data.slotdatas[slot_equipped].item
		or not inventory_data.slotdatas[slot_equipped].item.scene):
			return
	
	var new_item: Node = inventory_data.slotdatas[slot_equipped].item.scene.instantiate()
	camera_3d.add_child(new_item)
	new_item.owner = owner
	new_item.position = default_position

func update_slot() -> void:
	if current_slot != null:
		current_slot.theme = slot_themes.default
	
	if slot_equipped < 0:
		current_slot = null
		return
	
	var slot: PanelContainer = slot_container.get_node("slot_%s" % slot_equipped)
	if slot == null: return

	current_slot = slot
	slot.theme = slot_themes.equipped
