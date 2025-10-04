extends Control

@onready var black_overlay: ColorRect = %BlackOverlay
@onready var inventory_items: HBoxContainer = %InventoryItems
@onready var example_item: TextureRect = %ExampleItem

func _ready() -> void:
	InventoryManager.connect("inventory_updated", Callable(self, "_on_inventory_updated"))

	_on_inventory_updated()

	# DialogueManager.dialogue_container = %DialogueContainer
	# DialogueManager.dialogue_text_label = %DialogueText

func _on_inventory_updated() -> void:
	# Remove every item except the example item
	for child in inventory_items.get_children():
		if child != example_item:
			child.queue_free()

	# Add an icon for each item in the inventory
	for item in InventoryManager.inventory:
		var item_icon = example_item.duplicate() as TextureRect
		item_icon.texture = item.sprite
		item_icon.visible = true
		inventory_items.add_child(item_icon)
