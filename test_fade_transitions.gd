# Test script to demonstrate fade transitions
# Add this to a node in your scene and call the test functions
extends Node

func _ready():
	print("🎬 Fade Transition System Ready!")
	print("Available methods:")
	print("  • test_basic_transition() - Basic fade with default 0.5s duration")
	print("  • test_slow_transition() - Slow fade with 1.5s duration")
	print("  • test_fast_transition() - Fast fade with 0.2s duration")

# Test basic transition with default duration
func test_basic_transition():
	print("🔄 Starting basic transition to Dumpster1...")
	SceneManager.transition_to_scene(SceneManager.Scenes.DUMPSTER1)

# Test transition with slow fade
func test_slow_transition():
	print("🔄 Starting slow transition to Hub...")
	await SceneManager.transition_to_scene_with_duration(SceneManager.Scenes.HUB, 1.5)
	print("✅ Slow transition completed!")

# Test transition with fast fade
func test_fast_transition():
	print("🔄 Starting fast transition to Dumpster1...")
	await SceneManager.transition_to_scene_with_duration(SceneManager.Scenes.DUMPSTER1, 0.2)
	print("✅ Fast transition completed!")

# Example of changing the default fade duration
func change_default_fade_duration():
	print("⚙️ Changing default fade duration to 0.8 seconds")
	SceneManager.set_fade_duration(0.8)
	print("✅ Default fade duration updated!")

	# Now all transitions will use 0.8s by default
	SceneManager.transition_to_scene(SceneManager.Scenes.HUB)

# Test checking if transition is in progress
func test_transition_safety():
	if SceneManager.is_transitioning:
		print("⚠️ Transition already in progress - blocked!")
		return

	print("🔄 Starting transition...")
	SceneManager.transition_to_scene(SceneManager.Scenes.DUMPSTER1)

	# This would be blocked if called immediately
	if SceneManager.is_transitioning:
		print("✅ Safety check working - subsequent transition blocked!")

# Example usage for keyboard testing
func _input(event):
	if event.is_action_pressed("ui_accept"):  # Enter key
		test_basic_transition()
	elif event.is_action_pressed("ui_select"):  # Space key
		test_slow_transition()
	elif event.is_action_pressed("ui_cancel"):  # Escape key
		test_fast_transition()
