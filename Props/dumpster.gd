extends Node3D

@export var for_day: int
@export var to_scene: SceneManager.Scenes

@onready var label: Label3D = %Label3D
@onready var interactable_area: Area3D = %InteractableArea

func _ready() -> void:
	label.visible = false

	if GameManager.day != for_day:
		return

	interactable_area.connect("interact", Callable(self, "_on_interactable_area_interact"))
	interactable_area.connect("hovered", Callable(self, "_on_interactable_area_hovered"))
	interactable_area.connect("unhovered", Callable(self, "_on_interactable_area_unhovered"))

func _on_interactable_area_interact() -> void:
	if to_scene != null:
		SceneManager.transition_to_scene(to_scene)
	else:
		push_error("Dumpster node is missing its to_scene value!")

func _on_interactable_area_hovered() -> void:
	label.visible = true

func _on_interactable_area_unhovered() -> void:
	label.visible = false
