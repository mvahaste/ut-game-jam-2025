extends Sprite3D

@export var to_hub: bool = false

func _on_interactable_area_interact() -> void:
	print("Interacted with trash bag")

func _on_interactable_area_hovered() -> void:
	print("Hovering over trash bag")


func _on_interactable_area_unhovered() -> void:
	print("Stopped hovering over trash bag")
