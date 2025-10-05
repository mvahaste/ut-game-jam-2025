extends Node

@onready var fail_label: RichTextLabel = %FailLabel
@onready var success_label: RichTextLabel = %SuccessLabel

func _ready():
	# Start with all labels invisible
	success_label.modulate.a = 0.0
	fail_label.modulate.a = 0.0

	# Fade in labels one by one
	fade_in_sequence()

func fade_in_sequence():
	await get_tree().create_timer(1.0).timeout

	var tween1 = _fade_in_label(fail_label if GameManager.day_failed else success_label, 1.0)
	await tween1.finished

	await get_tree().create_timer(2.0).timeout

	_fade_out_label(fail_label if GameManager.day_failed else success_label, 1.0)

	await get_tree().create_timer(1.0).timeout

	SceneManager.transition_to_scene(SceneManager.Scenes.HUB)

func _fade_in_label(label: RichTextLabel, duration: float) -> Tween:
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 1.0, duration)
	return tween

func _fade_out_label(label: RichTextLabel, duration: float) -> Tween:
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 0.0, duration)
	return tween
