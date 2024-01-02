extends Node2D

var world_dictionary = {
	1: false,
	2: false,
	3: false
}

var player: Player
var current_world = 1

func _ready():
	player = Player.new()

func clear_stage():
	current_world += 1

func spawn_player():
	world_dictionary[current_world]
	
