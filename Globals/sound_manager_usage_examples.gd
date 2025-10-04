# Sound Manager Usage Examples
# This file shows how to use the SoundManager from anywhere in your game
# Note: This file contains examples only - the SoundManager calls will show errors 
# until you actually use them in real game scripts where SoundManager autoload is available

# =============================================================================
# BASIC SOUND EFFECTS
# =============================================================================

# Play a sound effect (from anywhere in your code)
func on_button_clicked():
	SoundManager.play_sfx(SoundManager.SFX.MENU_CLICK)

func on_player_walks():
	SoundManager.play_sfx(SoundManager.SFX.FOOTSTEP, -8.0)  # Quieter footstep

func on_item_picked_up():
	SoundManager.play_pickup()  # Using convenience method

func on_dumpster_opened():
	SoundManager.play_dumpster_open()

# =============================================================================
# BACKGROUND MUSIC
# =============================================================================

# Play background music (survives scene changes)
func start_main_theme():
	SoundManager.play_music(SoundManager.MUSIC.MAIN_THEME, 2.0)  # 2 second fade in

func switch_to_hub_music():
	SoundManager.crossfade_music(SoundManager.MUSIC.HUB_AMBIENT, 3.0)  # 3 second crossfade

func stop_all_music():
	SoundManager.stop_music(1.5)  # 1.5 second fade out

# =============================================================================
# VOLUME CONTROL
# =============================================================================

# Set volume levels (useful for settings menu)
func update_volume_settings(master: float, sfx: float, music: float):
	SoundManager.set_master_volume(master)  # 0.0 to 1.0
	SoundManager.set_sfx_volume(sfx)
	SoundManager.set_music_volume(music)

# Get current volume levels
func get_current_volumes():
	var master = SoundManager.get_master_volume()
	var sfx = SoundManager.get_sfx_volume() 
	var music = SoundManager.get_music_volume()
	print("Volumes - Master: ", master, " SFX: ", sfx, " Music: ", music)

# =============================================================================
# PAUSE/RESUME (useful for pause menus)
# =============================================================================

func on_game_paused():
	SoundManager.pause_music()

func on_game_resumed():
	SoundManager.resume_music()

# =============================================================================
# ADDING YOUR OWN AUDIO FILES
# =============================================================================

# 1. Create these folders in your project:
#    res://Audio/SFX/
#    res://Audio/Music/

# 2. Put your audio files there (.ogg format recommended for best performance)

# 3. In sound_manager.gd, uncomment and update the load_audio_resources() paths:
#    sfx_resources[SFX.MENU_CLICK] = load("res://Audio/SFX/menu_click.ogg")
#    music_resources[MUSIC.MAIN_THEME] = load("res://Audio/Music/main_theme.ogg")

# 4. Add more enum values to SFX or MUSIC enums as needed for your sounds

# =============================================================================
# EXAMPLE: Using in a Player script
# =============================================================================

# In your player.gd file:
#extends CharacterBody2D
#
#func _ready():
#	# Start background music when player loads
#	SoundManager.play_music(SoundManager.MUSIC.HUB_AMBIENT)
#
#func _physics_process(delta):
#	# Play footstep sounds when moving
#	if velocity.length() > 0 and is_on_floor():
#		# Only play footstep every so often to avoid spam
#		if not $FootstepTimer.is_stopped():
#			return
#		SoundManager.play_footstep()
#		$FootstepTimer.start(0.4)  # Wait 0.4 seconds before next footstep

# =============================================================================  
# EXAMPLE: Using in UI/Menu scripts
# =============================================================================

# In your menu.gd file:
#extends Control
#
#func _on_start_button_pressed():
#	SoundManager.play_ui_click()
#	# Switch to game music
#	SoundManager.crossfade_music(SoundManager.MUSIC.MAIN_THEME, 1.0)
#	# Load game scene...
#
#func _on_button_mouse_entered():
#	SoundManager.play_sfx(SoundManager.SFX.MENU_HOVER, -10.0)  # Quiet hover sound