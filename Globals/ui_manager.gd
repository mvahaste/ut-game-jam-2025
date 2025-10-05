extends Control

@export var hp_3_texture: Texture2D
@export var hp_2_texture: Texture2D
@export var hp_1_texture: Texture2D
@export var hp_0_texture: Texture2D

@onready var health_rect: TextureRect = %Health
@onready var black_overlay: ColorRect = %BlackOverlay
@onready var inventory_items: HBoxContainer = %InventoryItems
@onready var example_item: TextureRect = %ExampleItem

func _ready() -> void:
	InventoryManager.connect("inventory_updated", Callable(self, "_on_inventory_updated"))
	Globals.player_health_changed.connect(update_health_display)

	if SceneManager.is_scene_dumpster:
		health_rect.visible = true
	else:
		health_rect.visible = false

	_on_inventory_updated()

	DialogueManager.dialogue_container = %DialogueContainer
	DialogueManager.dialogue_text_label = %DialogueText

	fade_from_black()

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

# Fade overlay control methods
func fade_to_black(duration: float = 0.5) -> void:
	black_overlay.visible = true
	black_overlay.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(black_overlay, "modulate:a", 1.0, duration)
	await tween.finished

func fade_from_black(duration: float = 0.5) -> void:
	black_overlay.visible = true
	black_overlay.modulate.a = 1.0
	var tween = create_tween()
	tween.tween_property(black_overlay, "modulate:a", 0.0, duration)
	await tween.finished
	black_overlay.visible = false

func is_faded_to_black() -> bool:
	return black_overlay.visible and black_overlay.modulate.a >= 1.0

func set_black_overlay_visible(show_overlay: bool) -> void:
	black_overlay.visible = show_overlay
	if show_overlay:
		black_overlay.visible = true
		black_overlay.modulate.a = 1.0
	else:
		black_overlay.modulate.a = 0.0
		black_overlay.visible = false

func update_health_display(health: int) -> void:
	match health:
		3:
			health_rect.texture = hp_3_texture
		2:
			health_rect.texture = hp_2_texture
		1:
			health_rect.texture = hp_1_texture
		0:
			health_rect.texture = hp_0_texture
