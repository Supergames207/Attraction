extends Control
var slot := preload("res://UI/Inventory/slot.tscn")
#Right now this variable isn't used anywhere else than ready so we don't need to have it always in memory
#We may change this if we implement something else in this script
#var inventory_data := load("res://UI/Inventory/InventoryData.tres")

func _ready()->void:
	var inventory_data := load("res://UI/Inventory/InventoryData.tres")
	for i in range(len(inventory_data.slotdatas)):
		var new_slot := slot.instantiate()
		$GridContainer.add_child(new_slot)
		if not inventory_data.slotdatas[i] or not inventory_data.slotdatas[i].item: continue
		if inventory_data.slotdatas[i].item.texture:
			new_slot.get_node("Slot/Item").texture = inventory_data.slotdatas[i].item.texture
		if inventory_data.slotdatas[i].item.scene:
			pass
