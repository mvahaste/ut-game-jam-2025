class_name InteractionArea extends Area3D

var _hovered_area: InteractableArea = null

func _on_area_entered(area: Area3D) -> void:
	if area is InteractableArea:
		_hovered_area = area
		area.hovered.emit()

func _on_area_exited(area: Area3D) -> void:
	if area is InteractableArea:
		_hovered_area = null
		area.unhovered.emit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and _hovered_area:
		_hovered_area.interact.emit()
