extends Node2D

export (int) var level_index 
export (Color) var sky_color = Color.deepskyblue
export (String, FILE, "*.tscn") var previous_level_path
export (String, FILE, "*.tscn") var next_level_path
export (bool) var test_spawn = false

#onready var player: = $Player
onready var camera: = $PlayerRoot/Anchor/Camera2D
onready var spawn_point: = $SpawnPoint
onready var check_point: = $CheckPoint
onready var test_point: = $TestSpawn
onready var player_root: = $PlayerRoot
onready var camera_anchor: = $PlayerRoot/Anchor

const PlayerScene = preload("res://Player.tscn")
var player
var stage_cleared = false

func _ready():
	Events.connect("player_died", self, "_on_player_died")
	Events.connect("checkpoint_reached", self, "_on_checkpoint_reached")
	Events.connect("stage_cleared", self, "_on_stage_cleared")
	Transition.connect("transition_started", self, "_on_transition_started")
	Transition.connect("transition_completed", self, "_on_transition_completed")
	VisualServer.set_default_clear_color(sky_color)
	AudioManager.start_music_for_level(level_index)
	spawn_player()
	Transition.play_start_transition()
	CameraShaker.connect_anchor(camera_anchor)
		
func _on_player_died():
	spawn_player()

func _on_checkpoint_reached():
	Events.check_point_reached = true
	
func _on_stage_cleared():
	stage_cleared = true
	Events.check_point_reached = false
	Transition.play_exit_transition()
	
func spawn_player():
	player = PlayerScene.instance()
	player_root.add_child(player)
	player.connect_camera(camera_anchor)
	camera_anchor.connect_player(player)
	
	if test_spawn:
		player.position = test_point.position
		return
	if Events.check_point_reached:
		player.position = check_point.position
	else:
		player.position = spawn_point.position

func _on_transition_started():
	pass
	
func _on_transition_completed():
	if not stage_cleared: return
	if next_level_path == null: return
	get_tree().change_scene(next_level_path)
