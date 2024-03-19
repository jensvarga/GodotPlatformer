extends Node

# Events
signal player_died
signal checkpoint_reached
signal stage_cleared
signal lazer_beam_activated

# Global variables
var check_point_reached = false
var current_level = 1
var death_counter = 0

var unlocked_level_2 = false
var unlocked_level_3 = false

var player_overworld_position

var gates = {
	0: true,
	1: false,
	2: false,
}

func _ready():
	Events.connect("player_died", self, "_on_player_died")
	
func _on_player_died():
	death_counter += 1
