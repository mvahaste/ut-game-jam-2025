# Example script showing how to use the new fade transitions
extends Node

func _ready():
	print("Fade Transition Example loaded")
	print("Available transition methods:")
	print("1. SceneManager.transition_to_scene(target_scene)")
	print("2. SceneManager.transition_to_scene_with_duration(target_scene, duration)")
	print("3. SceneManager.set_fade_duration(duration)")

# Example of basic fade transition (uses default 0.5 second duration)
func example_basic_transition():
	SceneManager.transition_to_scene(SceneManager.Scenes.DUMPSTER1)

# Example of fade transition with custom duration
func example_custom_duration_transition():
	await SceneManager.transition_to_scene_with_duration(SceneManager.Scenes.HUB, 1.0)  # 1 second fade

# Example of changing default fade duration
func example_change_default_duration():
	SceneManager.set_fade_duration(0.8)  # Set default to 0.8 seconds
	SceneManager.transition_to_scene(SceneManager.Scenes.HUB)

# Example usage in a game context (like a door or portal)
func _on_portal_interact():
	# This would be called when player interacts with a portal/door
	await SceneManager.transition_to_scene(SceneManager.Scenes.DUMPSTER1)
	print("Arrived at new scene!")

# Example of checking if transition is in progress
func _on_button_pressed():
	if not SceneManager.is_transitioning:
		SceneManager.transition_to_scene(SceneManager.Scenes.HUB)
	else:
		print("Transition already in progress, please wait")
