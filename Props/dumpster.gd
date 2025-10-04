extends Node3D

@export var to_scene: SceneManager.Scenes

func _on_interactable_area_interact() -> void:
	if to_scene != null:
		SceneManager.transition_to_scene(to_scene)
	else:
		print("No scene assigned to dumpster")
