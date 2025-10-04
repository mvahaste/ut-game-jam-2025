extends CharacterBody3D

@export var speed := 3.0
@export var jump_force := 6.0
@export var gravity := 15.0
@export var detection_range := 6.0
@export var aggro_drop_time := 10.0
@export var attack_range := 1.5
@export var attack_cooldown := 1.0
@export var target: Node3D

var is_chasing := false
var last_seen_time := -1.0
var jump_cooldown := 1.2
var last_jump_time := -10.0
var last_attack_time := -10.0

func _physics_process(delta: float) -> void:
	if not target:
		return

	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	elif velocity.y < 0:
		velocity.y = 0

	var to_target = target.global_position - global_position
	to_target.y = 0
	var distance := to_target.length()
	var now := Time.get_ticks_msec() / 1000.0

	# Aggro logic (simplified)
	if distance < detection_range:
		is_chasing = true
		last_seen_time = now
	elif now - last_seen_time > aggro_drop_time:
		is_chasing = false

	# Movement / jumping
	if is_chasing:
		var dir := to_target.normalized()
		if is_on_floor() and now - last_jump_time > jump_cooldown:
			last_jump_time = now
			velocity.y = jump_force
			velocity.x = dir.x * speed
			velocity.z = dir.z * speed
			look_at(target.global_position, Vector3.UP)
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta)
		velocity.z = move_toward(velocity.z, 0, speed * delta)

	move_and_slide()

	# --- Attack logic ---
	if is_chasing and target and target is Player:
		if distance <= attack_range and now - last_attack_time >= attack_cooldown:
			last_attack_time = now
			target.lose_hp(1)
			print("Roach attacked player! Player HP =", target.hp)
