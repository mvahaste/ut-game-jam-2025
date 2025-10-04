extends Node

@onready var hub_scene: PackedScene = preload("res://world.tscn")
@onready var trash_bag_scene: PackedScene = preload("res://dumpster1.tscn")

func go_to_hub_scene() -> void:
	if hub_scene:
		get_tree().change_scene_to_packed(hub_scene)
	else:
		print("Hub scene not assigned in SceneManager")

func go_to_trash_bag_scene() -> void:
	if trash_bag_scene:
		get_tree().change_scene_to_packed(trash_bag_scene)
	else:
		print("Trash bag scene not assigned in SceneManager")
