extends Control

@onready var SLOT_CONTAINER: HBoxContainer = %SlotContainer

var slot_scene := preload("res://UI/Inventory/slot.tscn")

func _ready() -> void:
	# We don't use `inventory_data` anywhere else so it's fine to load in _ready().
	var inventory_data := load("res://UI/Inventory/InventoryData.tres")

	for i in range(len(inventory_data.slotdatas)):
		# Set the name so that we can access the slots from `InventoryManagement`
		var new_slot: PanelContainer = slot_scene.instantiate()
		new_slot.name = "slot_%s" % i
		new_slot.get_node("%ItemPosition").text = str(i + 1)

		SLOT_CONTAINER.add_child(new_slot)

		if not inventory_data.slotdatas[i] or not inventory_data.slotdatas[i].item:
			continue

		if inventory_data.slotdatas[i].item.texture:
			new_slot.get_node("Slot/Item").texture = inventory_data.slotdatas[i].item.texture
