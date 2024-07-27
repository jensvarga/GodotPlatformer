extends Node

# Events
signal player_died
signal player_take_damage
signal checkpoint_reached
signal stage_cleared
signal lazer_beam_activated
signal toggle_fullscreen
signal toggle_music
signal toggle_sound_effects
signal pick_up_ankh
signal damage_boss
signal boss_died

# Global variables
var check_point_reached = false
var current_level = 1
var death_counter = 0
var player_overworld_position
var collected_items = []
var player_hit_points = 1
var boss_hit_points = 6

var unlocked_level_2 = false
var unlocked_level_3 = false

var levels_cleared = {
	0: false,
	1: false,
	2: false,
	3: false,
	4: false,
	5: false
}

var gates = {
	0: true,
	1: false,
	2: false,
}

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Events.connect("player_died", self, "_on_player_died")
	Events.connect("toggle_fullscreen", self, "_on_toggle_fullscreen")
	Events.connect("toggle_music", self, "_on_toggle_music")
	Events.connect("toggle_sound_effects", self, "_on_toggle_sound_effects")
	Events.connect("player_take_damage", self, "_on_player_take_damage")
	Events.connect("pick_up_ankh", self, "_on_pick_up_ankh")
	Events.connect("damage_boss", self, "_on_damage_boss")

func _on_player_take_damage():
	if player_hit_points - 1 <= 0:
		Events.emit_signal("player_died")
		player_hit_points = 0
	else:
		player_hit_points = player_hit_points - 1

func _on_pick_up_ankh():
	if player_hit_points + 1 >= 3:
		player_hit_points = 3
	else:
		player_hit_points = player_hit_points + 1
		
func _on_player_died():
	death_counter += 1
	
func _on_toggle_fullscreen():
	OS.window_fullscreen = !OS.window_fullscreen

func _on_toggle_music():
	AudioServer.set_bus_mute(1, not AudioServer.is_bus_mute(1))

func _on_toggle_sound_effects():
	AudioServer.set_bus_mute(2, not AudioServer.is_bus_mute(2))

func _on_damage_boss():
	if boss_hit_points - 1 <= 0:
		Events.emit_signal("boss_died")
		boss_hit_points = 0
	else:
		boss_hit_points = boss_hit_points - 1
