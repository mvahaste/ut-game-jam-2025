extends Node

var is_dialogue_active: bool = false

var dialogue_container: Control
var dialogue_text_label: RichTextLabel

enum Dialogues {
	WISE_RAT_1,
	WISE_RAT_2,
	WISE_RAT_3,
	WISE_RAT_4,

	CRAZY_RAT_1,
	CRAZY_RAT_2,
	CRAZY_RAT_3,

	RACCOON_GANG_1,
	RACCOON_GANG_2,
	RACCOON_GANG_3,
	RACCOON_GANG_4,
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
		displayed_text += character
		char_index += 1

		if (dialogue_text[char_index - 1] == "$"):
			await get_tree().create_timer(0.25).timeout
			displayed_text = displayed_text.substr(0, displayed_text.length() - 1)
			continue

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

# "$" means a short pause in the dialogue
func start_dialogue(dialogue: Dialogues) -> void:
	var sounds: Array[SoundManager.SFX] = []

	match dialogue:
		Dialogues.WISE_RAT_1:
			sounds = [SoundManager.SFX.WISE_DIALOGUE_1, SoundManager.SFX.WISE_DIALOGUE_2]
			await _talk("Wise Rat", "My dear friend, it's good to see you again. I didn't think you'd return here anytime soon... the roaches are still relentless about protecting their trash in these parts.", sounds)
			await _talk("Wise Rat", "If you enter a container then make it quick, they're gonna close the lids soon.", sounds)
			end_dialogue()
			return
		Dialogues.WISE_RAT_2:
			sounds = [SoundManager.SFX.WISE_DIALOGUE_1, SoundManager.SFX.WISE_DIALOGUE_2]
			await _talk("Wise Rat", "This part of town, as you know, is not frequented by many other rats, therefore these garbage bins haven't been looted yet.", sounds)
			await _talk("Wise Rat", "I fear today is the last time I scour here, I'm not in good enough health to escape the roaches anymore...", sounds)
			end_dialogue()
			return
		Dialogues.WISE_RAT_3:
			sounds = [SoundManager.SFX.WISE_DIALOGUE_1, SoundManager.SFX.WISE_DIALOGUE_2]
			await _talk("Wise Rat", "...", sounds, 0.25, 1)
			await _talk("Wise Rat", "...", sounds, 0.25, 1)
			await _talk("Wise Rat", "My dear friend, you know, I found something quite nice in the dumpster today. I know  you have a large family, so here, you can have this:", sounds)
			await _talk("Wise Rat", "*Wise Rat gave you [Shiny Gum Wrapper]*", sounds)
			await _talk("Wise Rat", "You mustn't feel bad about me giving you this, I am simply an old rat and I don't need much to get by.", sounds)
			end_dialogue()
			return
		Dialogues.WISE_RAT_4:
			sounds = [SoundManager.SFX.WISE_DIALOGUE_1, SoundManager.SFX.WISE_DIALOGUE_2]
			await _talk("Wise Rat", "...", sounds, 0.25, 1)
			await _talk("Wise Rat", "If you wish to find valuables today, you ought to get to it, my friend. Soon they will close the containers.", sounds)
			end_dialogue()
			return
		Dialogues.CRAZY_RAT_1:
			sounds = [SoundManager.SFX.CRAZY_DIALOGUE_2, SoundManager.SFX.CRAZY_DIALOGUE_2, SoundManager.SFX.CRAZY_DIALOGUE_3]
			await _talk("Crazy Rat", "MEET MY FRIEND ARABELLA she is here in my arms.", sounds)
			await _talk("Crazy Rat", "She IS my very good friends and do you know who else is my good friend well the worms IN MY BRAIN are my good WORMS.", sounds)
			end_dialogue()
			return
		Dialogues.CRAZY_RAT_2:
			sounds = [SoundManager.SFX.CRAZY_DIALOGUE_2, SoundManager.SFX.CRAZY_DIALOGUE_2, SoundManager.SFX.CRAZY_DIALOGUE_3]
			await _talk("Crazy Rat", "MY LIGHTER IS SO WARM AND LIGHT do YOU KNOW THIS?", sounds)
			await _talk("Crazy Rat", "You Don't Understand........$$ Do You.......", sounds)
			end_dialogue()
			return
		Dialogues.CRAZY_RAT_3:
			sounds = [SoundManager.SFX.CRAZY_DIALOGUE_2, SoundManager.SFX.CRAZY_DIALOGUE_2, SoundManager.SFX.CRAZY_DIALOGUE_3]
			await _talk("Crazy Rat", "THE WORMS are my worms.", sounds)
			await _talk("Crazy Rat", "Would you be my WORM?", sounds)
			await _talk("Crazy Rat", "My worm my friendly worm You Are My Friends worm.", sounds)
			end_dialogue()
			return
		Dialogues.RACCOON_GANG_1:
			sounds = []
			await _talk("Raccoon Gang", "...", sounds, 0.5, 1)
			end_dialogue()
			return
		Dialogues.RACCOON_GANG_2:
			var left_sounds: Array[SoundManager.SFX] = [SoundManager.SFX.LEFT_COON_1, SoundManager.SFX.LEFT_COON_2]
			var right_sounds: Array[SoundManager.SFX] = [SoundManager.SFX.RIGHT_COON_1, SoundManager.SFX.RIGHT_COON_2]
			var boss_sounds: Array[SoundManager.SFX] = [SoundManager.SFX.BOSS_COON_1, SoundManager.SFX.BOSS_COON_2]
			await _talk("Left Coon", "Yo......$$ Uh, who the hell are you?", left_sounds)
			await _talk("Boss Coon", "Don't you know this territory is OUR turf, BRO?", boss_sounds)
			await _talk("Boss Coon", "We're gonna turn you into...$ Uhh...$ Umm...$ MEAT PASTE, unless you get going quick...", boss_sounds)
			await _talk("Right Coon", "HEH! Yeah bro, you better run!", right_sounds)
			await _talk("Boss Coon", "Because we WILL turn you into meat paste.", boss_sounds)
			await _talk("Left Coon", "And that's what we're gonna do.", left_sounds)
			await _talk("Boss Coon", "Yeah, man.", boss_sounds)
			end_dialogue()
			return
		Dialogues.RACCOON_GANG_3:
			var right_sounds: Array[SoundManager.SFX] = [SoundManager.SFX.RIGHT_COON_1, SoundManager.SFX.RIGHT_COON_2]
			var boss_sounds: Array[SoundManager.SFX] = [SoundManager.SFX.BOSS_COON_1, SoundManager.SFX.BOSS_COON_2]
			await _talk("Right Coon", "Or, well, maybe we won't do that, if you're cool?", right_sounds)
			await _talk("Boss Coon", "Are you cool? Would you join our cool and intimidating gang?", boss_sounds)
			end_dialogue()
			return
		Dialogues.RACCOON_GANG_4:
			var right_sounds: Array[SoundManager.SFX] = [SoundManager.SFX.RIGHT_COON_1, SoundManager.SFX.RIGHT_COON_2]
			var boss_sounds: Array[SoundManager.SFX] = [SoundManager.SFX.BOSS_COON_1, SoundManager.SFX.BOSS_COON_2]
			await _talk("Right Coon", "Wait, Really!?", right_sounds)
			await _talk("Boss Coon", "Yaaayyy!", boss_sounds)
			end_dialogue()
			return

func _wait_for_input() -> void:
	while true:
		if Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("interact"):
			print("Input detected, continuing dialogue...")
			break
		await get_tree().process_frame
