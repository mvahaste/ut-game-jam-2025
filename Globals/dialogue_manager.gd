extends Node

var is_dialogue_active: bool = false

var dialogue_container: Control
var dialogue_text_label: RichTextLabel

enum Dialogues {
	WISE_RAT
}

func _speaker_label(speaker_name: String) -> String:
	return "[font_size=64]" + speaker_name + "[/font_size]"

func _talk(speaker_name: String, dialogue_text: String, sounds: Array[SoundManager.SFX], interval: float = 0.01, skip_every_n_sound: int = 7) -> void:
	is_dialogue_active = true

	dialogue_container.visible = true

	var speaker_label = _speaker_label(speaker_name)

	var displayed_text = ""
	var char_index = 0

	for character in dialogue_text:
		if Input.is_action_just_released("interact"):
			dialogue_text_label.text = speaker_label + "\n" + dialogue_text
			await _wait_for_input()
			break

		displayed_text += character
		char_index += 1
		dialogue_text_label.text = speaker_label + "\n" + displayed_text

		if sounds.size() > 0 and char_index % skip_every_n_sound == 0:
			var random_sound = sounds[randi() % sounds.size()]
			SoundManager.play_sfx(random_sound, 0.0, 0.05)

		await get_tree().create_timer(interval).timeout

	await _wait_for_input()

func end_dialogue() -> void:
	is_dialogue_active = false
	dialogue_text_label.text = ""
	dialogue_container.visible = false

func start_dialogue(dialogue: Dialogues) -> void:
	var sounds: Array[SoundManager.SFX] = []

	match dialogue:
		Dialogues.WISE_RAT:
			sounds = [SoundManager.SFX.WISE_DIALOGUE_1, SoundManager.SFX.WISE_DIALOGUE_2]
			await _talk("Wise Rat", "My dear friend, it's good to see you again. I didn't think youd return here anytime soon... the roaches are still relentless about protecting their trash in these parts.", sounds)
			await _talk("Wise Rat", "If you enter a container then make it quick, they're gonna close the lids soon.", sounds)
			await _talk("Wise Rat", "This part of town, as you know, is not frequented by many other rats, therefore these garbage bins haven't been looted yet.", sounds)
			await _talk("Wise Rat", "I fear today is the last time I scour here, I'm not in good enough health to escape the roaches anymore...", sounds)
			end_dialogue()
			return

func _wait_for_input() -> void:
	while true:
		await get_tree().process_frame
		if Input.is_action_just_pressed("interact"):
			break
