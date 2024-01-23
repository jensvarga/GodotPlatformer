extends Node

# Events
signal player_died
signal checkpoint_reached
signal stage_cleared
signal lazer_beam_activated

# Global variables
var check_point_reached = false
var stage = 0
var death_counter = 0

var unlocked_level_2 = false

func _ready():
	Events.connect("player_died", self, "_on_player_died")
	
func _on_player_died():
	death_counter += 1
