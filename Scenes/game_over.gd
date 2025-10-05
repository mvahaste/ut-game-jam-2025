extends Node

@onready var fail_background: TextureRect = %FailBackground
@onready var win_background: TextureRect = %WinBackground
@onready var die_background: TextureRect = %DieBackground
@onready var result_label: RichTextLabel = %Label

var die_text = "Another victim has fallen at the hands of the relentless roaches.\nYour 10 rat children will patiently wait for you to return forever..."
var fail_text = "You failed to provide for your family.\nYour children have starved to death."
var win_text = "You have successfully provided for your family.\nYour children cheer as they see you return home safely."

func _ready() -> void:
	fail_background.visible = false
	win_background.visible = false
	die_background.visible = false

	match GameManager.final_result:
		GameManager.Result.DIE:
			die_background.visible = true
			result_label.text = die_text
			SoundManager.crossfade_music(SoundManager.MUSIC.LOSS, 1.0)
		GameManager.Result.LOSE:
			fail_background.visible = true
			result_label.text = fail_text
			SoundManager.crossfade_music(SoundManager.MUSIC.LOSS, 1.0)
		GameManager.Result.WIN:
			win_background.visible = true
			result_label.text = win_text
			SoundManager.crossfade_music(SoundManager.MUSIC.WIN, 1.0)

	await _wait_for_input()

	SceneManager.transition_to_scene(SceneManager.Scenes.MAIN_MENU)

func _wait_for_input() -> void:
	while true:
		if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("interact"):
			break
		await get_tree().process_frame
