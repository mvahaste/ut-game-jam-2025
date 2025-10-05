extends Node

@onready var paper: TextureRect = %Paper
@onready var label: RichTextLabel = %Text

var _paper_final_position: Vector2;

func _ready() -> void:
	_paper_final_position = paper.position
	# Position paper below the screen initially
	paper.position.y = get_viewport().get_visible_rect().size.y + paper.size.y
	_show_result()
	_slide_in_paper()

func _show_result() -> void:
	var text = ""

	for item in GameManager.items_sold:
		text += "%s +%d\n" % [item.name, item.value]

	text += "Total: %d\n" % GameManager.player_money_from_sales

	text += "\n"

	text += "Bills: -%d\n" % GameManager.money_needed_per_day
	text += "Money left: %d\n" % GameManager.player_money

	label.text = text

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		_slide_out_paper()

func _slide_in_paper() -> void:
	SoundManager.play_sfx(SoundManager.SFX.PAPER_SLIDE)

	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(paper, "position", _paper_final_position, 0.8)

func _slide_out_paper() -> void:
	SoundManager.play_sfx(SoundManager.SFX.PAPER_SLIDE_OUT, 0.0, 0.0, 0.15)

	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_CUBIC)

	# Calculate target position above the screen
	var target_position = Vector2(paper.position.x, -paper.size.y)
	tween.tween_property(paper, "position", target_position, 0.6)

	# Transition to next scene when animation completes
	tween.tween_callback(func(): SceneManager.transition_to_scene(SceneManager.Scenes.FAMILY))
