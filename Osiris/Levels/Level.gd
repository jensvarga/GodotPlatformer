extends Node2D

export (Color) var sky_color = Color.deepskyblue
export (String, FILE, "*.tscn") var previous_level_path
export (String, FILE, "*.tscn") var next_level_path
export (bool) var test_spawn = false

onready var player: = $Player
onready var camera: = $Camera2D
onready var spawn_point: = $SpawnPoint
onready var check_point: = $CheckPoint
onready var test_point: = $TestSpawn

const PlayerScene = preload("res://Player.tscn")

func _ready():
	Events.connect("player_died", self, "_on_player_died")
	Events.connect("checkpoint_reached", self, "_on_checkpoint_reached")
	Events.connect("stage_cleared", self, "_on_stage_cleared")
	VisualServer.set_default_clear_color(sky_color)
	spawn_player()
		
func _on_player_died():
	spawn_player()

func _on_checkpoint_reached():
	Events.check_point_reached = true
	
func _on_stage_cleared():
	if next_level_path == null: return
	Events.check_point_reached = false
	get_tree().change_scene(next_level_path)
	
func spawn_player():
	var player = PlayerScene.instance()
	add_child(player)
	player.connect_camera(camera)
	
	if test_spawn:
		player.position = test_point.position
		return
	if Events.check_point_reached:
		player.position = check_point.position
	else:
		player.position = spawn_point.position
		
