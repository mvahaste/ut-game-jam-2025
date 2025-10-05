extends Node

signal inventory_updated()

var max_items: int = 2

# Player inventory
var inventory: Array[BaseItem] = []

var hidden_inventory: Array[BaseItem] = []

func hidden_add_item(item: BaseItem) -> void:
	hidden_inventory.append(item)
	print("Added hidden item: %s" % item.name)

func add_item(item: BaseItem) -> bool:
	if inventory.size() < max_items:
		inventory.append(item)
		print("Added item: %s" % item.name)
		emit_signal("inventory_updated")
		return true
	else:
		print("Inventory full! Cannot add item: %s" % item.name)
		return false

func remove_item(index: int) -> void:
	if index >= 0 and index < inventory.size():
		var item = inventory[index]
		inventory.remove_at(index)
		print("Removed item: %s" % item.name)
		emit_signal("inventory_updated")
	else:
		print("Invalid index: %d" % index)
