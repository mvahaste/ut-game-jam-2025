# Sound Manager - Usage Guide

The Sound Manager provides easy-to-use audio functionality for your game with persistent background music and sound effects.

## Features

- **Sound Effects (SFX)**: Play multiple overlapping sound effects with enum-based identification
- **Background Music**: Persistent music that survives scene transitions
- **Volume Controls**: Separate volume controls for master, SFX, and music
- **Fade Effects**: Smooth fade in/out and crossfade transitions
- **Convenience Methods**: Quick access to common sounds

## Quick Start

### Playing Sound Effects

```gdscript
# Basic sound effect
SoundManager.play_sfx(SoundManager.SFX.MENU_CLICK)

# Sound effect with custom volume
SoundManager.play_sfx(SoundManager.SFX.FOOTSTEP, -8.0)  # Quieter

# Using convenience methods
SoundManager.play_ui_click()
SoundManager.play_footstep()
SoundManager.play_pickup()
```

### Background Music

```gdscript
# Play music with fade in
SoundManager.play_music(SoundManager.MUSIC.MAIN_THEME, 2.0)

# Crossfade to new music
SoundManager.crossfade_music(SoundManager.MUSIC.HUB_AMBIENT, 3.0)

# Stop music with fade out
SoundManager.stop_music(1.5)
```

### Volume Control

```gdscript
# Set volume levels (0.0 to 1.0)
SoundManager.set_master_volume(0.8)
SoundManager.set_sfx_volume(0.7)
SoundManager.set_music_volume(0.6)

# Get current volumes
var master = SoundManager.get_master_volume()
```

## Available Sound Effects

The following SFX enums are available:

- **UI**: `MENU_CLICK`, `MENU_HOVER`, `BUTTON_PRESS`
- **Player**: `FOOTSTEP`, `PICKUP_ITEM`, `DROP_ITEM`, `INTERACT`, `JUMP`
- **Dumpster**: `DUMPSTER_OPEN`, `DUMPSTER_CLOSE`, `TRASH_BAG_PICKUP`, `TRASH_BAG_DROP`, `ITEM_FOUND`
- **Ambient**: `COCKROACH_SCUTTLE`, `WIND_BLOW`, `METAL_CLANK`
- **Effects**: `SUCCESS`, `FAILURE`, `NOTIFICATION`

## Available Music Tracks

- `MAIN_THEME`
- `HUB_AMBIENT` 
- `DUMPSTER_AREA`
- `VICTORY_THEME`
- `MENU_MUSIC`

## Adding Your Audio Files

1. Create folders in your project:
   - `res://Audio/SFX/`
   - `res://Audio/Music/`

2. Add your audio files (.ogg format recommended)

3. In `sound_manager.gd`, uncomment and update the `load_audio_resources()` function:
   ```gdscript
   sfx_resources[SFX.MENU_CLICK] = load("res://Audio/SFX/menu_click.ogg")
   music_resources[MUSIC.MAIN_THEME] = load("res://Audio/Music/main_theme.ogg")
   ```

4. Add more enum values as needed for your sounds

## Example Usage in Game Scripts

### Player Movement
```gdscript
# In player.gd
func _ready():
    SoundManager.play_music(SoundManager.MUSIC.HUB_AMBIENT)

func _physics_process(delta):
    if velocity.length() > 0 and is_on_floor():
        if not $FootstepTimer.is_stopped():
            return
        SoundManager.play_footstep()
        $FootstepTimer.start(0.4)
```

### UI/Menu
```gdscript
# In menu.gd  
func _on_start_button_pressed():
    SoundManager.play_ui_click()
    SoundManager.crossfade_music(SoundManager.MUSIC.MAIN_THEME, 1.0)

func _on_button_mouse_entered():
    SoundManager.play_sfx(SoundManager.SFX.MENU_HOVER, -10.0)
```

### Pause Menu
```gdscript
func _on_game_paused():
    SoundManager.pause_music()

func _on_game_resumed():
    SoundManager.resume_music()
```

## Advanced Features

### Fade Effects
```gdscript
# Fade music in/out
SoundManager.fade_music_in(2.0)
SoundManager.fade_music_out(1.5)
```

### Music State
```gdscript
# Check if music is playing
if SoundManager.is_music_currently_playing():
    print("Music is playing")

# Get current music track
var current = SoundManager.get_current_music()
```

The Sound Manager is automatically loaded as a singleton and persists across all scenes, ensuring your music continues playing seamlessly during scene transitions.