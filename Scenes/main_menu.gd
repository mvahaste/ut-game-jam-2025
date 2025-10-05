extends Node

func _ready() -> void:
	SoundManager.play_music(SoundManager.MUSIC.MAIN_MENU)

func _on_start_button_pressed() -> void:
	SceneManager.transition_to_scene(SceneManager.Scenes.INTRO)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
