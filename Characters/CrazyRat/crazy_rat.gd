extends StaticBody3D

@onready var label: Label3D = %Label3D
@onready var interactable_area: Area3D = %InteractableArea

var _talk_count: int = 0

func _ready() -> void:
	if GameManager.day != 2:
		queue_free()
		return

	label.visible = false
	interactable_area.connect("interact", Callable(self, "_on_interactable_area_interact"))
	interactable_area.connect("hovered", Callable(self, "_on_interactable_area_hovered"))
	interactable_area.connect("unhovered", Callable(self, "_on_interactable_area_unhovered"))

func _on_interactable_area_interact() -> void:
	_talk_count += 1

	match _talk_count:
		1:
			DialogueManager.start_dialogue(DialogueManager.Dialogues.CRAZY_RAT_1)
		2:
			DialogueManager.start_dialogue(DialogueManager.Dialogues.CRAZY_RAT_2)
		3:
			DialogueManager.start_dialogue(DialogueManager.Dialogues.CRAZY_RAT_3)
		_:
			return

func _on_interactable_area_hovered() -> void:
	label.visible = true

func _on_interactable_area_unhovered() -> void:
	label.visible = false
