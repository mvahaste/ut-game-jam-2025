extends CharacterBody3D

enum State {
	PATROLLING,
	CHASING,
	ATTACKING,
	RETURNING
}

@export var patrol_points: Array[Node3D] = []
@export var patrol_radius: float = 3.0
@export var move_speed: float = 2.0
@export var chase_speed: float = 4.0
@export var vision_distance: float = 8.0
@export var attack_distance: float = 1.5
@export var max_chase_distance: float = 15.0
@export var patrol_wait_time_min: float = 1.0
@export var patrol_wait_time_max: float = 3.0
@export var attack_cooldown: float = 2.0
@export var pounce_force: float = 16.0
@export var pounce_height: float = 4.0
@export var gravity: float = 12.0

@onready var vision_raycast_parent: Node3D = %VisionRayCasts

var _vision_raycasts: Array[RayCast3D] = []
var _current_state: State = State.PATROLLING
var _target_position: Vector3
var _current_patrol_point: Node3D
var _patrol_center: Vector3
var _wait_timer: float = 0.0
var _attack_timer: float = 0.0
var _player: Player
var _last_player_position: Vector3

func _ready() -> void:
	for child in vision_raycast_parent.get_children():
		if child is RayCast3D:
			_vision_raycasts.append(child)

	# Find the player
	_player = get_tree().get_first_node_in_group("player") as Player
	if not _player:
		# Fallback: search for Player type directly
		var players = get_tree().get_nodes_in_group("player")
		for node in players:
			if node is Player:
				_player = node as Player
				break

		# If still not found, search the entire tree
		if not _player:
			_player = _find_player_in_tree(get_tree().root)

		if not _player:
			print("Warning: No player found in scene!")

	# Start patrolling
	_start_patrol()

func _physics_process(delta: float) -> void:
	_update_timers(delta)

	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	match _current_state:
		State.PATROLLING:
			_handle_patrol_state(delta)
		State.CHASING:
			_handle_chase_state(delta)
		State.ATTACKING:
			_handle_attack_state(delta)
		State.RETURNING:
			_handle_return_state(delta)

	move_and_slide()

func _update_timers(delta: float) -> void:
	if _wait_timer > 0:
		_wait_timer -= delta
	if _attack_timer > 0:
		_attack_timer -= delta

func _handle_patrol_state(delta: float) -> void:
	# Check for player
	if _can_see_player():
		_start_chase()
		return

	# Handle movement to patrol target
	if _wait_timer <= 0:
		# Only consider X and Z axes for distance calculation
		var flat_position = Vector3(global_position.x, 0, global_position.z)
		var flat_target = Vector3(_target_position.x, 0, _target_position.z)
		var distance_to_target = flat_position.distance_to(flat_target)

		if distance_to_target > 0.5:
			_move_towards(_target_position, move_speed, delta)
		else:
			# Reached target, wait then pick new target
			_wait_timer = randf_range(patrol_wait_time_min, patrol_wait_time_max)
			_pick_new_patrol_target()

func _handle_chase_state(delta: float) -> void:
	if not _player:
		_start_patrol()
		return

	# Only consider X and Z axes for distance calculations
	var flat_position = Vector3(global_position.x, 0, global_position.z)
	var flat_player_pos = Vector3(_player.global_position.x, 0, _player.global_position.z)
	var flat_patrol_center = Vector3(_patrol_center.x, 0, _patrol_center.z)
	var distance_to_player = flat_position.distance_to(flat_player_pos)
	var distance_to_patrol_center = flat_position.distance_to(flat_patrol_center)

	# Check if player is too far or we're too far from patrol area
	if distance_to_player > max_chase_distance or distance_to_patrol_center > max_chase_distance:
		_start_return()
		return

	# Check if close enough to attack
	if distance_to_player <= attack_distance and _attack_timer <= 0:
		_start_attack()
		return

	# Check if player is still visible
	if not _can_see_player():
		# Move to last known position
		_move_towards(_last_player_position, chase_speed, delta)

		# If we reached last known position and still can't see player, return to patrol
		var flat_current_pos = Vector3(global_position.x, 0, global_position.z)
		var flat_last_pos = Vector3(_last_player_position.x, 0, _last_player_position.z)
		if flat_current_pos.distance_to(flat_last_pos) < 1.0:
			_start_return()
	else:
		# Update last known position and chase
		_last_player_position = _player.global_position
		_move_towards(_player.global_position, chase_speed, delta)

func _handle_attack_state(_delta: float) -> void:
	if not _player:
		_start_patrol()
		return

	# Only consider X and Z axes for distance calculation
	var flat_position = Vector3(global_position.x, 0, global_position.z)
	var flat_player_pos = Vector3(_player.global_position.x, 0, _player.global_position.z)
	var distance_to_player = flat_position.distance_to(flat_player_pos)

	# If player moved away, return to chasing
	if distance_to_player > attack_distance * 1.5:
		_start_chase()
		return

	# Perform pounce attack
	if _attack_timer <= 0:
		_pounce_at_player()
		_attack_timer = attack_cooldown

func _handle_return_state(delta: float) -> void:
	# Check for player again while returning (in case they come back)
	if _can_see_player():
		var flat_pos_check = Vector3(global_position.x, 0, global_position.z)
		var flat_patrol_check = Vector3(_patrol_center.x, 0, _patrol_center.z)
		var distance_to_patrol_center = flat_pos_check.distance_to(flat_patrol_check)
		if distance_to_patrol_center < max_chase_distance * 0.7:  # Only chase if not too far
			_start_chase()
			return

	# Move back to patrol area
	var flat_position = Vector3(global_position.x, 0, global_position.z)
	var flat_patrol_center = Vector3(_patrol_center.x, 0, _patrol_center.z)
	var distance_to_patrol = flat_position.distance_to(flat_patrol_center)

	if distance_to_patrol > 1.0:
		_move_towards(_patrol_center, move_speed, delta)
	else:
		# Back in patrol area, resume patrolling
		_start_patrol()

func _move_towards(target: Vector3, speed: float, _delta: float) -> void:
	# Only consider X and Z axes for pathfinding (ignore Y/elevation)
	var flat_target = Vector3(target.x, global_position.y, target.z)
	var direction = (flat_target - global_position).normalized()
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	# Look towards movement direction
	if direction.length() > 0:
		look_at(global_position + direction, Vector3.UP)

func _can_see_player() -> bool:
	if not _player:
		return false

	# Only consider X and Z axes for vision distance
	var flat_position = Vector3(global_position.x, 0, global_position.z)
	var flat_player_pos = Vector3(_player.global_position.x, 0, _player.global_position.z)
	var distance_to_player = flat_position.distance_to(flat_player_pos)
	if distance_to_player > vision_distance:
		return false

	# Check with raycasts
	for raycast in _vision_raycasts:
		if raycast.is_colliding():
			var collider = raycast.get_collider()
			if collider and collider is Player:
				return true

	# Fallback: direct line of sight check
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(
		global_position + Vector3(0, 0.5, 0),
		_player.global_position + Vector3(0, 0.5, 0)
	)
	var result = space_state.intersect_ray(query)

	if result and result.collider and result.collider is Player:
		return true

	return false

func _start_patrol() -> void:
	_current_state = State.PATROLLING
	_pick_new_patrol_target()

func _start_chase() -> void:
	_current_state = State.CHASING
	if _player:
		_last_player_position = _player.global_position

func _start_attack() -> void:
	_current_state = State.ATTACKING

func _start_return() -> void:
	_current_state = State.RETURNING

func _pick_new_patrol_target() -> void:
	if patrol_points.is_empty():
		return

	# Pick a random patrol point
	_current_patrol_point = patrol_points[randi() % patrol_points.size()]
	_patrol_center = _current_patrol_point.global_position

	# Pick a random point within patrol radius
	var random_offset = Vector3(
		randf_range(-patrol_radius, patrol_radius),
		0,
		randf_range(-patrol_radius, patrol_radius)
	)

	_target_position = _patrol_center + random_offset

func _pounce_at_player() -> void:
	if not _player:
		return

	# Calculate direction to player (only X and Z axes)
	var flat_target = Vector3(_player.global_position.x, global_position.y, _player.global_position.z)
	var direction = (flat_target - global_position).normalized()

	# Apply pounce velocity
	velocity.x = direction.x * pounce_force
	velocity.z = direction.z * pounce_force
	velocity.y = pounce_height

	# Deal damage to player if they have a health system
	if _player.has_method("take_damage"):
		_player.take_damage(1)

	# Return to chasing after pounce
	_start_chase()

func _find_player_in_tree(node: Node) -> Player:
	if node is Player:
		return node as Player

	for child in node.get_children():
		var result = _find_player_in_tree(child)
		if result:
			return result

	return null
