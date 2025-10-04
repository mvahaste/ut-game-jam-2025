extends CanvasLayer

@onready var panel = $Panel
@onready var text_label = $Panel/Layout/Text
var npc_world_pos: Vector3 = Vector3.ZERO
var player: Node = null

func show_text(message: String, world_pos: Vector3, player_ref: Node = null):
	text_label.text = message
	visible = true
	npc_world_pos = world_pos
	if player_ref:
		player = player_ref
		player.can_move = false

func hide_text():
	visible = false
	if player:
		player.can_move = true
		player = null

func _process(_delta: float) -> void:
	if visible:
		var camera = get_viewport().get_camera_3d()
		if camera:
			var screen_pos = camera.unproject_position(npc_world_pos)
			
			panel.position = screen_pos - Vector2(panel.size.x * 0.5, panel.size.y + 40)


func _on_leave_button_pressed() -> void:
	hide_text()
