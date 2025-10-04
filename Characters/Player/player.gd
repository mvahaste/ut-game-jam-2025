class_name Player extends CharacterBody3D

@export var speed := 5.0
@export var camera: Camera3D
@export var camera_target: Node3D
@export var camera_allowed_distance := 1.0

func _ready() -> void:
	camera.top_level = true

func _physics_process(_delta: float) -> void:
	_process_movement()
	_interpolate_camera()

	move_and_slide()

func _process_movement() -> void:
	var input_vector = Vector2.ZERO

	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	if input_vector.length() > 0:
		input_vector = input_vector.normalized()
		var direction = (transform.basis * Vector3(input_vector.x, 0, input_vector.y)).normalized()
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

func _interpolate_camera() -> void:
	var target_position = camera_target.global_transform.origin
	var camera_position = camera.global_transform.origin
	var distance = camera_position.distance_to(target_position)

	if distance > camera_allowed_distance:
		var direction = (target_position - camera_position).normalized()
		var new_position = target_position - direction * camera_allowed_distance
		camera.global_transform.origin = lerp(camera_position, new_position, 0.1)
