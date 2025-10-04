extends CharacterBody3D

@export var speed := 5.0
@export var camera: Camera3D

func _physics_process(_delta: float) -> void:
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

	move_and_slide()
