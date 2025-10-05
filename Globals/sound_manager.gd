extends Node

enum SFX {
	WISE_DIALOGUE_1,
	WISE_DIALOGUE_2,

	CRAZY_DIALOGUE_1,
	CRAZY_DIALOGUE_2,
	CRAZY_DIALOGUE_3,

	LEFT_COON_1,
	LEFT_COON_2,
	BOSS_COON_1,
	BOSS_COON_2,
	RIGHT_COON_1,
	RIGHT_COON_2,

	HOP,
	LAND,
	CONFIRM,
	DIE,
	DODGE,
	GAME_OVER,
	HIT,
	PAPER_SLIDE,
	PAPER_SLIDE_OUT,
	SELECT,
	SPOTTED,
}

enum MUSIC {
	MAIN_MENU,
	DIVE,
	DIVE_COMPLETED,
	RACCOON_THEME,
	WIN,
	LOSS
}

# AudioStreamPlayer nodes for different audio types
@onready var music_player: AudioStreamPlayer
@onready var sfx_players: Array[AudioStreamPlayer] = []

# Audio resources - these should be loaded with actual audio files
var sfx_resources: Dictionary = {}
var music_resources: Dictionary = {}

# Audio settings
var master_volume: float = 1.0
var sfx_volume: float = 1.0
var music_volume: float = 0.7
var max_concurrent_sfx: int = 8

# Current state
var _current_music: MUSIC
var _is_music_playing: bool = false
var _current_music_set: bool = false

func _ready():
	setup_audio_players()
	load_audio_resources()

	process_mode = Node.PROCESS_MODE_ALWAYS

func setup_audio_players():
	# Create music player
	music_player = AudioStreamPlayer.new()
	music_player.name = "MusicPlayer"
	music_player.bus = "Master"
	add_child(music_player)

	# Create multiple SFX players for overlapping sounds
	for i in max_concurrent_sfx:
		var sfx_player = AudioStreamPlayer.new()
		sfx_player.name = "SFXPlayer" + str(i)
		sfx_player.bus = "Master"
		add_child(sfx_player)
		sfx_players.append(sfx_player)

func load_audio_resources():
	sfx_resources[SFX.WISE_DIALOGUE_1] = load("res://Characters/WiseRat/WiseDialogue1.wav")
	sfx_resources[SFX.WISE_DIALOGUE_2] = load("res://Characters/WiseRat/WiseDialogue2.wav")

	sfx_resources[SFX.CRAZY_DIALOGUE_1] = load("res://Characters/CrazyRat/CrazyDialogue1.wav")
	sfx_resources[SFX.CRAZY_DIALOGUE_2] = load("res://Characters/CrazyRat/CrazyDialogue2.wav")
	sfx_resources[SFX.CRAZY_DIALOGUE_3] = load("res://Characters/CrazyRat/CrazyDialogue3.wav")

	sfx_resources[SFX.LEFT_COON_1] = load("res://Characters/RaccoonGang/LeftCoon1.wav")
	sfx_resources[SFX.LEFT_COON_2] = load("res://Characters/RaccoonGang/LeftCoon2.wav")

	sfx_resources[SFX.BOSS_COON_1] = load("res://Characters/RaccoonGang/BossCoon1.wav")
	sfx_resources[SFX.BOSS_COON_2] = load("res://Characters/RaccoonGang/BossCoon2.wav")

	sfx_resources[SFX.RIGHT_COON_1] = load("res://Characters/RaccoonGang/RightCoon1.wav")
	sfx_resources[SFX.RIGHT_COON_2] = load("res://Characters/RaccoonGang/RightCoon2.wav")

	sfx_resources[SFX.HOP] = load("res://Sfx/Hop.wav")
	sfx_resources[SFX.LAND] = load("res://Sfx/Land.wav")
	sfx_resources[SFX.CONFIRM] = load("res://Sfx/Confirm.wav")
	sfx_resources[SFX.DIE] = load("res://Sfx/Die.wav")
	sfx_resources[SFX.DODGE] = load("res://Sfx/Dodge.wav")
	sfx_resources[SFX.GAME_OVER] = load("res://Sfx/GameOver.wav")
	sfx_resources[SFX.HIT] = load("res://Sfx/Hit.wav")
	sfx_resources[SFX.PAPER_SLIDE] = load("res://Sfx/PaperSlide.wav")
	sfx_resources[SFX.PAPER_SLIDE_OUT] = load("res://Sfx/PaperSlideOut.wav")
	sfx_resources[SFX.SELECT] = load("res://Sfx/Select.wav")
	sfx_resources[SFX.SPOTTED] = load("res://Sfx/Spotted.wav")

	music_resources[MUSIC.MAIN_MENU] = load("res://Music/MainMenuAndHub.mp3")
	music_resources[MUSIC.DIVE] = load("res://Music/DiveMusic.WAV")
	music_resources[MUSIC.DIVE_COMPLETED] = load("res://Music/DiveCompleted.wav")
	music_resources[MUSIC.RACCOON_THEME] = load("res://Music/RaccoonTheme.mp3")
	music_resources[MUSIC.WIN] = load("res://Music/Victory_Music.mp3")
	music_resources[MUSIC.LOSS] = load("res://Music/Lose_Ending.mp3")

	print("Sound Manager: Audio resources loaded")

# =============================================================================
# PUBLIC API - Call these functions from anywhere in your game
# =============================================================================

# Play a sound effect
func play_sfx(sfx: SFX, volume_db: float = 0.0, pitch_variance: float = 0.0, delay: float = 0.0) -> void:
	if not sfx_resources.has(sfx):
		print("Sound Manager Warning: SFX resource not found for: ", SFX.keys()[sfx])
		return

	var player = get_available_sfx_player()
	if player == null:
		print("Sound Manager Warning: No available SFX players")
		return

	player.stream = sfx_resources[sfx]
	player.volume_db = volume_db + linear_to_db(sfx_volume * master_volume)
	player.pitch_scale = 1.0 + randf_range(-pitch_variance, pitch_variance)

	if delay > 0.0:
		await get_tree().create_timer(delay).timeout

	player.play()

# Play background music (survives scene changes)
func play_music(music: MUSIC, fade_in_duration: float = 1.0) -> void:
	if not music_resources.has(music):
		print("Sound Manager Warning: Music resource not found for: ", MUSIC.keys()[music])
		return

	# If same music is already playing, don't restart
	if _current_music_set and _current_music == music and _is_music_playing:
		return

	# Stop current music if playing
	if _is_music_playing:
		stop_music(fade_in_duration * 0.5)
		await get_tree().create_timer(fade_in_duration * 0.5).timeout

	# Start new music
	_current_music = music
	_current_music_set = true
	music_player.stream = music_resources[music]
	music_player.volume_db = linear_to_db(music_volume * master_volume)

	music_player.play()
	_is_music_playing = true

	# Fade in if requested
	if fade_in_duration > 0:
		fade_music_in(fade_in_duration)

# Stop background music
func stop_music(fade_out_duration: float = 1.0) -> void:
	if not _is_music_playing:
		return

	if fade_out_duration > 0:
		fade_music_out(fade_out_duration)
		await get_tree().create_timer(fade_out_duration).timeout

	music_player.stop()
	_is_music_playing = false

# Stop all sound effects
func stop_all_sfx() -> void:
	for player in sfx_players:
		player.stop()

# =============================================================================
# HELPER METHODS
# =============================================================================

func get_available_sfx_player() -> AudioStreamPlayer:
	# Find the first non-playing SFX player
	for player in sfx_players:
		if not player.playing:
			return player

	# If all are playing, use the first one (interrupt it)
	return sfx_players[0]

# =============================================================================
# VOLUME CONTROL
# =============================================================================

# Set master volume (0.0 to 1.0)
func set_master_volume(volume: float) -> void:
	master_volume = clamp(volume, 0.0, 1.0)
	update_all_volumes()

# Set SFX volume (0.0 to 1.0)
func set_sfx_volume(volume: float) -> void:
	sfx_volume = clamp(volume, 0.0, 1.0)
	update_all_volumes()

# Set music volume (0.0 to 1.0)
func set_music_volume(volume: float) -> void:
	music_volume = clamp(volume, 0.0, 1.0)
	if music_player:
		music_player.volume_db = linear_to_db(music_volume * master_volume)

# Update all volume levels
func update_all_volumes() -> void:
	# Update music volume
	if music_player:
		music_player.volume_db = linear_to_db(music_volume * master_volume)

	# SFX volumes are updated per-play call, so no need to update existing sounds

# Get current volume levels
func get_master_volume() -> float:
	return master_volume

func get_sfx_volume() -> float:
	return sfx_volume

func get_music_volume() -> float:
	return music_volume

# =============================================================================
# FADE EFFECTS AND UTILITY METHODS
# =============================================================================

# Fade music in over duration
func fade_music_in(duration: float) -> void:
	if not music_player or not _is_music_playing:
		return

	var start_volume = -80.0  # Start from silence
	var target_volume = linear_to_db(music_volume * master_volume)

	music_player.volume_db = start_volume

	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", target_volume, duration)

# Fade music out over duration
func fade_music_out(duration: float) -> void:
	if not music_player or not _is_music_playing:
		return

	var target_volume = -80.0  # Fade to silence

	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", target_volume, duration)

# Crossfade from current music to new music
func crossfade_music(new_music: MUSIC, duration: float = 2.0) -> void:
	if get_current_music() == new_music and is_music_currently_playing():
		return  # Already playing this music

	if not music_resources.has(new_music):
		print("Sound Manager Warning: Music resource not found for crossfade: ", MUSIC.keys()[new_music])
		return

	# If same music, don't crossfade
	if _current_music_set and _current_music == new_music and _is_music_playing:
		return

	var fade_out_duration = duration * 0.5
	var fade_in_duration = duration * 0.5

	# Fade out current music
	if _is_music_playing:
		fade_music_out(fade_out_duration)
		await get_tree().create_timer(fade_out_duration).timeout
		music_player.stop()

	# Start new music and fade in
	_current_music = new_music
	_current_music_set = true
	music_player.stream = music_resources[new_music]

	music_player.play()
	_is_music_playing = true
	fade_music_in(fade_in_duration)

# Check if music is currently playing
func is_music_currently_playing() -> bool:
	return _is_music_playing and music_player.playing

# Get currently playing music
func get_current_music() -> MUSIC:
	if _current_music_set:
		return _current_music
	else:
		# Return the first enum value as default if no music set
		return MUSIC.values()[0]

# Pause/Resume music (useful for pause menus)
func pause_music() -> void:
	if music_player and _is_music_playing:
		music_player.stream_paused = true

func resume_music() -> void:
	if music_player and _is_music_playing:
		music_player.stream_paused = false
