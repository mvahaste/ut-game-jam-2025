class_name Player extends CharacterBody3D

@export var speed := 5.0
@export var camera: Camera3D
@export var camera_target: Node3D
@export var camera_allowed_distance := 1.0
@export var animated_sprite: AnimatedSprite3D
@export var interaction_area: Area3D

var current_direction := "Down"  # Track current facing direction
var is_moving := false

func _ready() -> void:
	camera.top_level = true

func _physics_process(_delta: float) -> void:
	_process_movement()
	_update_animation()
	_interpolate_camera()

	move_and_slide()

func _process_movement() -> void:
	var input_vector = Vector2.ZERO

	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	if input_vector.length() > 0:
		input_vector = input_vector.normalized()
		is_moving = true

		# Determine direction based on input
		_update_direction(input_vector)

		# Update interaction area rotation based on input direction
		_update_interaction_area_rotation(input_vector)

		var direction = (transform.basis * Vector3(input_vector.x, 0, input_vector.y)).normalized()
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		is_moving = false
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

func _update_direction(input_vector: Vector2) -> void:
	# Determine direction based on the strongest input component
	if abs(input_vector.x) > abs(input_vector.y):
		# Horizontal movement is stronger
		if input_vector.x > 0:
			current_direction = "Right"
		else:
			current_direction = "Left"
	else:
		# Vertical movement is stronger
		if input_vector.y > 0:
			current_direction = "Down"
		else:
			current_direction = "Up"

func _update_animation() -> void:
	if not animated_sprite:
		return

	var animation_name: String

	if is_moving:
		animation_name = "Walk" + current_direction
	else:
		animation_name = "Idle" + current_direction

	# Only change animation if it's different from current one
	if animated_sprite.animation != animation_name:
		animated_sprite.play(animation_name)

func _update_interaction_area_rotation(input_vector: Vector2) -> void:
	if not interaction_area:
		return

	# Calculate the angle from the input vector
	# We need to negate Y because input Y is inverted (positive Y = down in input, but up in 3D world)
	var angle = atan2(-input_vector.y, input_vector.x)

	# Convert to 3D rotation around the Y axis (vertical axis)
	# We add PI/2 to align with Godot's coordinate system where Z-forward is the default
	var rotation_y = angle + PI/2

	# Apply the rotation to the interaction area
	interaction_area.rotation.y = rotation_y
