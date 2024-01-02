extends Node2D

onready var player: = $Player
onready var camera: = $Camera2D
onready var spawn_point: = $SpawnPoint
onready var check_point: = $CheckPoint

const PlayerScene = preload("res://Player.tscn")

func _ready():
	Events.connect("player_died", self, "_on_player_died")
	Events.connect("checkpoint_reached", self, "_on_checkpoint_reached")
	#VisualServer.set_default_clear_color(Color.lightskyblue)
	VisualServer.set_default_clear_color(Color.deepskyblue)
	spawn_player()
		
func _on_player_died():
	spawn_player()
	
func _on_checkpoint_reached():
	Events.check_point_reached = true
	
func spawn_player():
	var player = PlayerScene.instance()
	add_child(player)
	player.connect_camera(camera)
	
	if Events.check_point_reached:
		player.position = check_point.position
	else:
		player.position = spawn_point.position

