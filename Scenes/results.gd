extends Node

@onready var label: RichTextLabel = %Text

func _ready() -> void:
	_show_result()

func _show_result() -> void:
	var text = ""

	for item in GameManager.items_sold:
		text += "%s - %d\n" % [item.name, item.sell_price]

	label.text = text
