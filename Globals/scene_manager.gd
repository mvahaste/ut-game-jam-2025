extends Node

enum Scenes {
	HUB,
	DUMPSTER1,
}

const SCENE_PATHS = {
	Scenes.HUB: "res://Scenes/Hub.tscn",
	Scenes.DUMPSTER1: "res://Scenes/Dumpster1.tscn",
}

var current_scene: Scenes = Scenes.HUB
var previous_scene: Scenes = Scenes.HUB

func transition_to_scene(target_scene: Scenes) -> void:
	if target_scene in SCENE_PATHS:
		previous_scene = current_scene
		current_scene = target_scene
		var scene_path = SCENE_PATHS[target_scene]
		var error = get_tree().change_scene_to_file(scene_path)
		if error != OK:
			push_error("Failed to change scene to %s" % scene_path)
	else:
		push_error("Scene %s not found in SCENE_PATHS" % str(target_scene))
