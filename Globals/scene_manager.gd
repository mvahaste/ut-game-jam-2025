extends Node

enum Scenes {
	MAIN_MENU,
	HUB,
	DUMPSTER1,
	DUMPSTER2,
	DUMPSTER3,
	INTRO,
	RESULTS,
	FAMILY,
	GAME_OVER,
}

const SCENE_PATHS = {
	Scenes.MAIN_MENU: "res://Scenes/MainMenu.tscn",
	Scenes.HUB: "res://Scenes/Hub.tscn",
	Scenes.DUMPSTER1: "res://Scenes/Dumpster1.tscn",
	Scenes.DUMPSTER2: "res://Scenes/Dumpster2.tscn",
	Scenes.DUMPSTER3: "res://Scenes/Dumpster3.tscn",
	Scenes.INTRO: "res://Scenes/intro_scene.tscn",
	Scenes.RESULTS: "res://Scenes/results.tscn",
	Scenes.FAMILY: "res://Scenes/family_scene.tscn",
	Scenes.GAME_OVER: "res://Scenes/game_over.tscn",
}

var current_scene: Scenes = Scenes.HUB
var previous_scene: Scenes = Scenes.HUB
var fade_duration: float = 0.5
var is_transitioning: bool = false

func transition_to_scene(target_scene: Scenes) -> void:
	if is_transitioning:
		return  # Prevent multiple transitions at once

	if target_scene in SCENE_PATHS:
		is_transitioning = true
		previous_scene = current_scene
		current_scene = target_scene
		var scene_path = SCENE_PATHS[target_scene]

		_start_music_for_scene(target_scene)

		# Start fade transition
		await _fade_transition(scene_path)

		is_transitioning = false
	else:
		push_error("Scene %s not found in SCENE_PATHS" % str(target_scene))

func _fade_transition(scene_path: String) -> void:
	# Try to find the UI manager in the current scene tree
	var ui_manager = _find_ui_manager()
	if not ui_manager:
		# Fallback to immediate transition if UI not available
		_change_scene_immediate(scene_path)
		return

	# Check if ui_manager has the fade methods
	if not ui_manager.has_method("fade_to_black"):
		# Fallback to immediate transition if methods not available
		_change_scene_immediate(scene_path)
		return

	# Fade to black
	await ui_manager.fade_to_black(fade_duration)

	# Change scene while screen is black
	var error = get_tree().change_scene_to_file(scene_path)
	if error != OK:
		push_error("Failed to change scene to %s" % scene_path)
		is_transitioning = false
		return

	# Wait one frame for the new scene to load
	await get_tree().process_frame

	# Try to find the UI manager in the new scene
	ui_manager = _find_ui_manager()
	if ui_manager and ui_manager.has_method("fade_from_black"):
		# Fade from black
		await ui_manager.fade_from_black(fade_duration)

func _find_ui_manager():
	# First try the typical UI autoload path
	var ui_manager = get_node_or_null("/root/UI/Control")
	if ui_manager:
		return ui_manager

	# If not found, search in the current scene tree
	var scene_root = get_tree().current_scene
	if scene_root:
		# Look for UI node in the current scene
		var ui_nodes = scene_root.find_children("UI", "CanvasLayer", false, false)
		for ui_node in ui_nodes:
			var control_node = ui_node.get_node_or_null("Control")
			if control_node:
				return control_node

	return null

func _change_scene_immediate(scene_path: String) -> void:
	var error = get_tree().change_scene_to_file(scene_path)
	if error != OK:
		push_error("Failed to change scene to %s" % scene_path)

func set_fade_duration(duration: float) -> void:
	fade_duration = duration

func transition_to_scene_with_duration(target_scene: Scenes, duration: float) -> void:
	var old_duration = fade_duration
	fade_duration = duration
	await transition_to_scene(target_scene)
	fade_duration = old_duration

func _start_music_for_scene(scene: Scenes) -> void:
	pass
	match scene:
		Scenes.RESULTS:
			SoundManager.crossfade_music(SoundManager.MUSIC.MAIN_MENU, 1.0)
