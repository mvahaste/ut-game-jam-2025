extends Sprite3D

@export var to_scene: PackedScene

func _on_interactable_area_interact() -> void:
	if to_scene:
		get_tree().change_scene_to_packed(to_scene)
	else:
		print("No scene assigned to trash bag")


func _on_interactable_area_hovered() -> void:
	print("Hovering over trash bag")


func _on_interactable_area_unhovered() -> void:
	print("Stopped hovering over trash bag")
