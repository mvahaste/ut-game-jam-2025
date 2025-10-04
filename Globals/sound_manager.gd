extends Node

# Sound Manager - Handles all audio playback for the game
# SFX and Music with persistent music across scene changes
# 
# USAGE EXAMPLES:
# SoundManager.play_sfx(SoundManager.SFX.MENU_CLICK)
# SoundManager.play_music(SoundManager.MUSIC.MAIN_THEME)
# SoundManager.play_footstep()  # Convenience method
# SoundManager.set_master_volume(0.8)
# SoundManager.crossfade_music(SoundManager.MUSIC.HUB_AMBIENT, 2.0)
#
# TO ADD YOUR AUDIO FILES:
# 1. Put your audio files (.ogg recommended) in res://Audio/SFX/ and res://Audio/Music/
# 2. Uncomment and update the paths in load_audio_resources() function below
# 3. Add more SFX/MUSIC enum values as needed

# Enum for all sound effects - makes calling them easy from anywhere
enum SFX {
	# UI Sounds
	MENU_CLICK,
	MENU_HOVER,
	BUTTON_PRESS,
	
	# Player Actions  
	FOOTSTEP,
	PICKUP_ITEM,
	DROP_ITEM,
	INTERACT,
	JUMP,
	
	# Dumpster/Trash Sounds
	DUMPSTER_OPEN,
	DUMPSTER_CLOSE,
	TRASH_BAG_PICKUP,
	TRASH_BAG_DROP,
	ITEM_FOUND,
	
	# Ambient/Environmental
	COCKROACH_SCUTTLE,
	WIND_BLOW,
	METAL_CLANK,
	
	# Special Effects
	SUCCESS,
	FAILURE,
	NOTIFICATION,
}

# Enum for background music tracks
enum MUSIC {
	MAIN_THEME,
	HUB_AMBIENT,
	DUMPSTER_AREA,
	VICTORY_THEME,
	MENU_MUSIC,
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
var current_music: MUSIC
var is_music_playing: bool = false
var current_music_set: bool = false

func _ready():
	# Initialize the sound manager
	setup_audio_players()
	load_audio_resources()
	
	# Make sure this node persists across scenes
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
	# Load SFX resources (replace these paths with actual audio file paths)
	# This is where you'll load your .ogg, .wav, or .mp3 files
	
	# UI Sounds
	# sfx_resources[SFX.MENU_CLICK] = load("res://Audio/SFX/menu_click.ogg")
	# sfx_resources[SFX.MENU_HOVER] = load("res://Audio/SFX/menu_hover.ogg") 
	# sfx_resources[SFX.BUTTON_PRESS] = load("res://Audio/SFX/button_press.ogg")
	
	# Player Actions
	# sfx_resources[SFX.FOOTSTEP] = load("res://Audio/SFX/footstep.ogg")
	# sfx_resources[SFX.PICKUP_ITEM] = load("res://Audio/SFX/pickup.ogg")
	# sfx_resources[SFX.DROP_ITEM] = load("res://Audio/SFX/drop.ogg")
	# sfx_resources[SFX.INTERACT] = load("res://Audio/SFX/interact.ogg")
	# sfx_resources[SFX.JUMP] = load("res://Audio/SFX/jump.ogg")
	
	# Dumpster/Trash Sounds  
	# sfx_resources[SFX.DUMPSTER_OPEN] = load("res://Audio/SFX/dumpster_open.ogg")
	# sfx_resources[SFX.DUMPSTER_CLOSE] = load("res://Audio/SFX/dumpster_close.ogg")
	# sfx_resources[SFX.TRASH_BAG_PICKUP] = load("res://Audio/SFX/trash_pickup.ogg")
	# sfx_resources[SFX.TRASH_BAG_DROP] = load("res://Audio/SFX/trash_drop.ogg")
	# sfx_resources[SFX.ITEM_FOUND] = load("res://Audio/SFX/item_found.ogg")
	
	# Load Music resources
	# music_resources[MUSIC.MAIN_THEME] = load("res://Audio/Music/main_theme.ogg")
	# music_resources[MUSIC.HUB_AMBIENT] = load("res://Audio/Music/hub_ambient.ogg")
	# music_resources[MUSIC.DUMPSTER_AREA] = load("res://Audio/Music/dumpster_area.ogg")
	# music_resources[MUSIC.VICTORY_THEME] = load("res://Audio/Music/victory.ogg")
	# music_resources[MUSIC.MENU_MUSIC] = load("res://Audio/Music/menu.ogg")
	
	print("Sound Manager: Audio resources loaded")

# =============================================================================
# PUBLIC API - Call these functions from anywhere in your game
# =============================================================================

# Play a sound effect
func play_sfx(sfx: SFX, volume_db: float = 0.0) -> void:
	if not sfx_resources.has(sfx):
		print("Sound Manager Warning: SFX resource not found for: ", SFX.keys()[sfx])
		return
	
	var player = get_available_sfx_player()
	if player == null:
		print("Sound Manager Warning: No available SFX players")
		return
	
	player.stream = sfx_resources[sfx]
	player.volume_db = volume_db + linear_to_db(sfx_volume * master_volume)
	player.play()

# Play background music (survives scene changes)
func play_music(music: MUSIC, fade_in_duration: float = 1.0) -> void:
	if not music_resources.has(music):
		print("Sound Manager Warning: Music resource not found for: ", MUSIC.keys()[music])
		return
	
	# If same music is already playing, don't restart
	if current_music_set and current_music == music and is_music_playing:
		return
	
	# Stop current music if playing
	if is_music_playing:
		stop_music(fade_in_duration * 0.5)
		await get_tree().create_timer(fade_in_duration * 0.5).timeout
	
	# Start new music
	current_music = music
	current_music_set = true
	music_player.stream = music_resources[music]
	music_player.volume_db = linear_to_db(music_volume * master_volume)
	music_player.play()
	is_music_playing = true
	
	# Fade in if requested
	if fade_in_duration > 0:
		fade_music_in(fade_in_duration)

# Stop background music
func stop_music(fade_out_duration: float = 1.0) -> void:
	if not is_music_playing:
		return
	
	if fade_out_duration > 0:
		fade_music_out(fade_out_duration)
		await get_tree().create_timer(fade_out_duration).timeout
	
	music_player.stop()
	is_music_playing = false

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
	if not music_player or not is_music_playing:
		return
	
	var start_volume = -80.0  # Start from silence
	var target_volume = linear_to_db(music_volume * master_volume)
	
	music_player.volume_db = start_volume
	
	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", target_volume, duration)

# Fade music out over duration
func fade_music_out(duration: float) -> void:
	if not music_player or not is_music_playing:
		return
	
	var target_volume = -80.0  # Fade to silence
	
	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", target_volume, duration)

# Crossfade from current music to new music
func crossfade_music(new_music: MUSIC, duration: float = 2.0) -> void:
	if not music_resources.has(new_music):
		print("Sound Manager Warning: Music resource not found for crossfade: ", MUSIC.keys()[new_music])
		return
	
	# If same music, don't crossfade
	if current_music_set and current_music == new_music and is_music_playing:
		return
	
	var fade_out_duration = duration * 0.5
	var fade_in_duration = duration * 0.5
	
	# Fade out current music
	if is_music_playing:
		fade_music_out(fade_out_duration)
		await get_tree().create_timer(fade_out_duration).timeout
		music_player.stop()
	
	# Start new music and fade in
	current_music = new_music
	current_music_set = true
	music_player.stream = music_resources[new_music]
	music_player.play()
	is_music_playing = true
	fade_music_in(fade_in_duration)

# Check if music is currently playing
func is_music_currently_playing() -> bool:
	return is_music_playing and music_player.playing

# Get currently playing music
func get_current_music() -> MUSIC:
	if current_music_set:
		return current_music
	else:
		# Return the first enum value as default if no music set
		return MUSIC.values()[0]

# Pause/Resume music (useful for pause menus)
func pause_music() -> void:
	if music_player and is_music_playing:
		music_player.stream_paused = true

func resume_music() -> void:
	if music_player and is_music_playing:
		music_player.stream_paused = false

# =============================================================================
# CONVENIENCE METHODS FOR COMMON GAME ACTIONS  
# =============================================================================

# Quick methods for common sound effects (you can add more as needed)
func play_ui_click() -> void:
	play_sfx(SFX.MENU_CLICK)

func play_footstep() -> void:
	play_sfx(SFX.FOOTSTEP, -5.0)  # Quieter footsteps

func play_pickup() -> void:
	play_sfx(SFX.PICKUP_ITEM)

func play_dumpster_open() -> void:
	play_sfx(SFX.DUMPSTER_OPEN)

func play_success() -> void:
	play_sfx(SFX.SUCCESS)

func play_failure() -> void:
	play_sfx(SFX.FAILURE)
