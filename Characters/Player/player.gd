class_name Player extends CharacterBody3D

@export var health: int = 3
@export var walk_speed: float = 5.0
@export var walk_acceleration: float = 0.75

@onready var interaction_area: Area3D = $InteractionArea
@onready var animated_sprite: AnimatedSprite3D = %AnimatedSprite3D

var is_dead: bool = false

var _last_animation_type: String = "Idle"
var _last_animation_direction: String = "Down"

func _ready() -> void:
	# Add to player group for cockroach detection
	add_to_group("player")

func _physics_process(_delta: float) -> void:
	if DialogueManager.is_dialogue_active or is_dead:
		velocity = Vector3.ZERO
		_handle_animation()
		_rotate_interaction_area(Vector2.ZERO)
		move_and_slide()
		return

	var input = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized();

	_handle_movement(input, _delta)
	_handle_animation()
	_rotate_interaction_area(input)

func _handle_movement(input: Vector2, _delta: float) -> void:
	if !input.is_equal_approx(Vector2.ZERO):
		var direction = (transform.basis * Vector3(input.x, 0, input.y)).normalized()

		# If trying to move in opposite direction than before, increase acceleration for a snappier turn
		if velocity.x != 0 and sign(direction.x) != sign(velocity.x):
			walk_acceleration *= 3.0
		else:
			walk_acceleration = 0.75

		if velocity.z != 0 and sign(direction.z) != sign(velocity.z):
			walk_acceleration *= 3.0
		else:
			walk_acceleration = 0.75

		velocity.x = move_toward(velocity.x, direction.x * walk_speed, walk_acceleration)
		velocity.z = move_toward(velocity.z, direction.z * walk_speed, walk_acceleration)
	else:
		if velocity.length() <= 0.5:
			velocity.x = 0
			velocity.z = 0
		else:
			velocity.x = move_toward(velocity.x, 0, walk_acceleration * 1.5)
			velocity.z = move_toward(velocity.z, 0, walk_acceleration * 1.5)

	move_and_slide()

func _handle_animation() -> void:
	var animation_type: String = "Idle"
	var animation_direction: String = _last_animation_direction

	if velocity.length() > 0.75:
		animation_type = "Walk"

		if abs(velocity.x) >= abs(velocity.z):
			if velocity.x > 0:
				animation_direction = "Right"
			else:
				animation_direction = "Left"
		else:
			if velocity.z > 0:
				animation_direction = "Down"
			else:
				animation_direction = "Up"

	var last_animation = "%s%s" % [_last_animation_type, _last_animation_direction]
	var new_animation = "%s%s" % [animation_type, animation_direction]

	if new_animation != last_animation:
		_last_animation_type = animation_type
		_last_animation_direction = animation_direction
		animated_sprite.play(new_animation)

func _rotate_interaction_area(input: Vector2) -> void:
	if input.is_equal_approx(Vector2.ZERO):
		return

	var angle = atan2(input.x, input.y)
	interaction_area.rotation.y = angle

func take_damage(amount: int) -> void:
	health -= amount
	SoundManager.play_sfx(SoundManager.SFX.HIT)
	print("Player took ", amount, " damage! Health: ", health)

	# Add visual feedback or sound effects here
	if health <= 0:
		_die()

func _die() -> void:
	if is_dead:
		return

	SoundManager.play_sfx(SoundManager.SFX.DIE)
	is_dead = true
	animated_sprite.visible = false
