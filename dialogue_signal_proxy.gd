class_name DialogueSignalProxy extends Node

signal letter_spoken(index: int)

static var instance: DialogueSignalProxy

func _ready() -> void:
	instance = self


func _on_dialogue_label_spoke(letter: String, letter_index: int, speed: float) -> void:
	letter_spoken.emit(letter_index)
