extends CharacterBody3D

@onready var vision_raycast_parent: Node3D = %VisionRayCasts

var _vision_raycasts: Array[RayCast3D] = []

func _ready() -> void:
	for child in vision_raycast_parent.get_children():
		if child is RayCast3D:
			_vision_raycasts.append(child)
