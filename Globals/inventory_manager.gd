extends Node

signal inventory_updated()

var max_items: int = 3

# Player inventory
var inventory: Array[BaseItem] = []

func add_item(item: BaseItem) -> bool:
	if inventory.size() < max_items:
		inventory.append(item)
		print("Added item: %s" % item.name)
		emit_signal("inventory_updated")
		return true
	else:
		print("Inventory full! Cannot add item: %s" % item.name)
		return false
