extends Node

@onready var label1: RichTextLabel = %Label1
@onready var label2: RichTextLabel = %Label2
@onready var label3: RichTextLabel = %Label3

func _ready():
	# Start with all labels invisible
	label1.modulate.a = 0.0
	label2.modulate.a = 0.0
	label3.modulate.a = 0.0

	# Fade in labels one by one
	fade_in_sequence()

func fade_in_sequence():
	await get_tree().create_timer(1.0).timeout

	var tween1 = create_tween()
	tween1.tween_property(label1, "modulate:a", 1.0, 1.0)
	await tween1.finished

	await get_tree().create_timer(1.0).timeout

	var tween2 = create_tween()
	tween2.tween_property(label2, "modulate:a", 1.0, 1.0)
	await tween2.finished

	await get_tree().create_timer(1.0).timeout

	var tween3 = create_tween()
	tween3.tween_property(label3, "modulate:a", 1.0, 1.0)
	await tween3.finished

	await get_tree().create_timer(3.0).timeout

	# Fade all to black
	var fade_tween = create_tween()
	fade_tween.parallel().tween_property(label1, "modulate:a", 0.0, 1.0)
	fade_tween.parallel().tween_property(label2, "modulate:a", 0.0, 1.0)
	fade_tween.parallel().tween_property(label3, "modulate:a", 0.0, 1.0)
	await fade_tween.finished

	SceneManager.transition_to_scene(SceneManager.Scenes.HUB)
