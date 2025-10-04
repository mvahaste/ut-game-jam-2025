extends Sprite3D

func _on_interactable_area_interact():
	var dialogue_box = get_tree().get_first_node_in_group("dialogue_ui")
	var player = get_tree().get_first_node_in_group("player")
	
	var world_pos = global_transform.origin + Vector3(0, 1.2, 0)
	
	dialogue_box.show_text("Hey there, traveler!", world_pos, player)
