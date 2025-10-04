class_name WiseRat extends StaticBody3D

@onready var label: Label3D = %Label3D
@onready var interactable_area: Area3D = %InteractableArea
@export var dialogue: DialogueResource

var _talk_count: int = 0
var _signal_connected: bool = false
var _sounds = [SoundManager.SFX.WISE_DIALOGUE_1, SoundManager.SFX.WISE_DIALOGUE_2]

func _ready() -> void:
	label.visible = false
	interactable_area.connect("interact", Callable(self, "_on_interactable_area_interact"))
	interactable_area.connect("hovered", Callable(self, "_on_interactable_area_hovered"))
	interactable_area.connect("unhovered", Callable(self, "_on_interactable_area_unhovered"))

func _physics_process(_delta: float) -> void:
	if _signal_connected:
		return

	if DialogueSignalProxy.instance:
		DialogueSignalProxy.instance.letter_spoken.connect(_on_letter_spoken)
		_signal_connected = true

func _on_interactable_area_interact() -> void:
	_talk_count += 1

	if _talk_count > 3:
		return

	DialogueManager.show_dialogue_balloon(dialogue, _get_dialogue_title())
	pass

func _on_interactable_area_hovered() -> void:
	label.visible = true

func _on_interactable_area_unhovered() -> void:
	label.visible = false

func _get_dialogue_title() -> String:
	match _talk_count:
		1:
			return "first"
		2:
			return "second"
		3:
			return "third"

	return "";

func _on_letter_spoken(index: int) -> void:
	if index % 5 == 0:
		var random_sound = _sounds[randi() % _sounds.size()]
		SoundManager.play_sfx(random_sound, 0.0, 0.05)
