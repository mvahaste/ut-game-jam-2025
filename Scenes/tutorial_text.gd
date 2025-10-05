extends RichTextLabel

func _ready() -> void:
	GameManager.tutorial_text = self

	if (GameManager.tutorial_dismissed):
		queue_free()
		return
