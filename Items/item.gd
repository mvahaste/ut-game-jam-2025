class_name Item extends Node3D

@export var item_resource: BaseItem
@onready var sprite: Sprite3D = %Sprite3D

func _ready():
	if item_resource and sprite:
		sprite.texture = item_resource.sprite


func _on_interactable_area_interact() -> void:
	var add_result = InventoryManager.add_item(item_resource)

	if (add_result):
		queue_free()
