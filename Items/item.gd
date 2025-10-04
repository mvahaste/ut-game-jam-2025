@tool
class_name Item extends Node3D

@export var item_resource: BaseItem : set = set_item_resource
@onready var sprite: Sprite3D = %Sprite3D
@onready var label: Label3D = %Label3D
@onready var interactable_area: Area3D = %InteractableArea

func _ready():
	update_item_display()

	if not Engine.is_editor_hint():
		# Only connect signals when running the game, not in editor
		interactable_area.connect("interact", Callable(self, "_on_interactable_area_interact"))
		interactable_area.connect("hovered", Callable(self, "_on_interactable_area_hovered"))
		interactable_area.connect("unhovered", Callable(self, "_on_interactable_area_unhovered"))

func set_item_resource(value: BaseItem):
	item_resource = value
	update_item_display()

func update_item_display():
	if !item_resource:
		if not Engine.is_editor_hint():
			push_error("Item node is missing its item_resource!")
		return

	# Get references to child nodes (works in both editor and runtime)
	var sprite_node = get_node_or_null("%Sprite3D")
	var label_node = get_node_or_null("%Label3D")

	if sprite_node:
		sprite_node.texture = item_resource.sprite

	if label_node:
		label_node.text = item_resource.name
		label_node.visible = Engine.is_editor_hint() # Show label in editor, hide in game initially



func _on_interactable_area_interact() -> void:
	var add_result = InventoryManager.add_item(item_resource)

	if (add_result):
		queue_free()

func _on_interactable_area_hovered() -> void:
	if not Engine.is_editor_hint():
		label.visible = true

func _on_interactable_area_unhovered() -> void:
	if not Engine.is_editor_hint():
		label.visible = false
