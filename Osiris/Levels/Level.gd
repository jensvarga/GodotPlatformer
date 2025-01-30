extends Node2D

export (int) var level_index
export (Color) var sky_color = Color.deepskyblue
export (String, FILE, "*.tscn") var previous_level_path
export (String, FILE, "*.tscn") var next_level_path = "res://Levels/OverworldLevel.tscn"
export (bool) var test_spawn = false
export (bool) var boss_level = false

#onready var player: = $Player
onready var spawn_point: = $SpawnPoint
onready var check_point: = $CheckPoint
onready var test_point: = $TestSpawn
onready var player_root: = $PlayerRoot
onready var camera_anchor: = $PlayerRoot/Anchor
onready var player_camera := $PlayerCamera

const PlayerScene = preload("res://Player.tscn")
export (AudioStream) var level_music = null
var player
var stage_cleared = false

func _ready():
	Events.current_level = level_index
	Events.connect("player_died", self, "_on_player_died")
	Events.connect("checkpoint_reached", self, "_on_checkpoint_reached")
	Events.connect("stage_cleared", self, "_on_stage_cleared")
	Transition.connect("transition_started", self, "_on_transition_started")
	Transition.connect("transition_completed", self, "_on_transition_completed")
	VisualServer.set_default_clear_color(sky_color)
	AudioManager.start_level_music(level_music)
	Transition.play_start_transition()
	CameraShaker.connect_anchor(camera_anchor)
	Events.set_deferred("player_hit_points", Events.max_player_hit_points)
	call_deferred("spawn_player")
		
func _on_player_died():
	spawn_player()

func _on_checkpoint_reached():
	Events.check_point_reached = true
	
func _on_stage_cleared():
	stage_cleared = true
	Events.check_point_reached = false
	Events.unlocked_level_2 = true
	Events.unlocked_level_3 = true
	Transition.play_exit_transition()
	
func spawn_player():
	player = PlayerScene.instance()
	if test_spawn:
		player.position = test_point.position
	elif Events.check_point_reached:
		player.position = check_point.position
	else:
		player.position = spawn_point.position
		
	player_root.call_deferred("add_child", player)
	player.connect_camera(camera_anchor)
	camera_anchor.connect_player(player)
	Events.player = player
	Events.player_camera = player_camera
	Events.emit_signal("player_spawned")
	
func _on_transition_started():
	pass
	
func _on_transition_completed():
	if not stage_cleared: return
	if next_level_path == null: return
	AudioManager.current_level = 0
	Events.levels_cleared[level_index] = true
	get_tree().change_scene(next_level_path)

func _on_AutosaveTimer_timeout():
	Events.save_game_data()
	print("Game autosaved")
