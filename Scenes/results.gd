extends Node

@onready var label: RichTextLabel = %Text

func _ready() -> void:
	_show_result()

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
		SceneManager.transition_to_scene(SceneManager.Scenes.FAMILY)
