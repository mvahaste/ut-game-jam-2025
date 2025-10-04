extends Node3D

@onready var player = $Player
@onready var roach = $Roach

func _ready() -> void:
	roach.target = player
