extends Sprite3D

@export var to_hub: bool = false

func _on_interactable_area_interact() -> void:
	if to_hub:
		SceneManager.go_to_hub_scene()
	else:
		SceneManager.go_to_trash_bag_scene()

func _on_interactable_area_hovered() -> void:
	print("Hovering over trash bag")


func _on_interactable_area_unhovered() -> void:
	print("Stopped hovering over trash bag")
