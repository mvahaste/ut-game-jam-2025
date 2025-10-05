extends Node3D

@onready var label: Label3D = %Label3D
@onready var interactable_area: Area3D = %InteractableArea

func _ready() -> void:
	label.visible = false
	interactable_area.connect("interact", Callable(self, "_on_interactable_area_interact"))
	interactable_area.connect("hovered", Callable(self, "_on_interactable_area_hovered"))
	interactable_area.connect("unhovered", Callable(self, "_on_interactable_area_unhovered"))

func _on_interactable_area_interact() -> void:
	GameManager.end_day()

func _on_interactable_area_hovered() -> void:
	label.visible = true

func _on_interactable_area_unhovered() -> void:
	label.visible = false
