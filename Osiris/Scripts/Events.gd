extends Node

const SAVE_FILE_PATH := "user://save/"
const SAVE_FILE_NAME := "SaveGame.tres"

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
signal pick_up_power_crook
signal pick_up_power_up
signal gained_life
signal killed_miniboss
signal ra_jumped
signal player_spawned
signal pick_up_talaria
signal update_overworld_level_label
signal update_lapis_count
signal advance_dialouge_index

# Global variables
var check_point_reached = false
var current_level = 1
var death_counter = 0
var player_hit_points = 3
var max_player_hit_points = 3
var boss_hit_points = 12
var has_power_crook = false
var lives = 3
var has_talaria = false
var lapis_ids = []

var family_friendly_mode = false

# Bodyparts
var has_left_hand = false
var has_right_hand = false
var has_pen15 = false
var has_head = false
var has_left_foot = false
var has_right_foot = false
var has_torso = false

# Overworld values
var player_overworld_position
var ra_in_cave = false
var ra_has_jumped = false
var dark_overworld_water = false
var overworld_level_label = ""
var granite_block_moved = false
var hraf_position: Vector2 = Vector2(-297, 854)

# Lighthouse (Unsaved)
var lighthouse_level: bool = false
var lighthouse_counter = 0
var best_lighthouse_counter = 0 # Saved

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Events.connect("player_died", self, "_on_player_died")
	Events.connect("toggle_fullscreen", self, "_on_toggle_fullscreen")
	Events.connect("toggle_music", self, "_on_toggle_music")
	Events.connect("toggle_sound_effects", self, "_on_toggle_sound_effects")
	Events.connect("player_take_damage", self, "_on_player_take_damage")
	Events.connect("pick_up_ankh", self, "_on_pick_up_ankh")
	Events.connect("damage_boss", self, "_on_damage_boss")
	Events.connect("pick_up_power_crook", self, "_on_pick_up_power_crook")
	Events.connect("gained_life", self, "on_gained_life")
	Events.connect("ra_jumped", self, "_on_ra_jumped")
	Events.connect("pick_up_talaria", self, "_on_pick_up_talaria")

func on_gained_life():
	var count = lives + 1
	lives = min(count, 99)
	
func _on_pick_up_power_crook():
	has_power_crook = true
	Events.emit_signal("pick_up_power_up")

func _on_pick_up_talaria():
	has_talaria = true
	
func _on_player_take_damage():
	if player_hit_points - 1 <= 0:
		player_hit_points = 0
	else:
		player_hit_points = player_hit_points - 1

func _on_pick_up_ankh():
	if player_hit_points + 1 >= max_player_hit_points:
		player_hit_points = max_player_hit_points
	else:
		player_hit_points = player_hit_points + 1
	Events.emit_signal("pick_up_power_up")
		
func _on_player_died():
	player = null
	death_counter += 1
	if Events.lighthouse_level:
			return
	if (lives - 1) <= 0:
		lives = 0
	else:
		lives = lives - 1
	player_hit_points = max_player_hit_points
	
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

# Smooth camera transitions
var player_camera: PlayerCamera
var player: Player = null
 
var room_pause: bool = false
export var room_pause_time: float = 0.2
  
func change_room(room_position: Vector2, room_size: Vector2) -> void:
	if player == null:
		print("no player found in Events.change_room")
		return
	if player_camera == null:
		print("no player_camera found Events.change_room")
		return
		
	player_camera.current_room_center = room_position
	player_camera.current_room_size = room_size
 
	room_pause = true
	yield(get_tree().create_timer(room_pause_time),"timeout")
	room_pause = false

func _on_ra_jumped():
	ra_has_jumped = true

func has_all_bodyparts() -> bool:
	if has_head and \
		has_left_hand and \
		has_right_hand and \
		has_left_foot and \
		has_right_foot and \
		has_pen15:
		return true
	return false

func verify_save_directory(path: String):
	var dir = Directory.new()
	
	if not dir.dir_exists(path):
		var err = dir.make_dir_recursive(path)
		if err != OK:
			print("Failed to create directory: ", path)
		else:
			print("Directory created successfully: ", path)
	else:
		print("Directory already exists: ", path)

func save_game_data():
	verify_save_directory(SAVE_FILE_PATH)
	var save_game = SaveGame.new()

	save_game.death_counter = Events.death_counter
	save_game.player_hit_points = Events.player_hit_points
	save_game.max_player_hit_points = Events.max_player_hit_points

	save_game.has_power_crook = Events.has_power_crook
	save_game.has_talaria = Events.has_talaria
	save_game.lives = Events.lives

	save_game.has_left_hand = Events.has_left_hand
	save_game.has_right_hand = Events.has_right_hand
	save_game.has_pen15 = Events.has_pen15
	save_game.has_head = Events.has_head
	save_game.has_left_foot = Events.has_left_foot
	save_game.has_right_foot = Events.has_right_foot
	save_game.has_torso = Events.has_torso

	save_game.player_overworld_position = Events.player_overworld_position
	save_game.ra_in_cave = Events.ra_in_cave
	save_game.ra_has_jumped = Events.ra_has_jumped
	save_game.dark_overworld_water = Events.dark_overworld_water
	save_game.granite_block_moved = Events.granite_block_moved
	save_game.hraf_position = Events.hraf_position

	save_game.lapis_ids = Events.lapis_ids
	save_game.best_lighthouse_counter = Events.best_lighthouse_counter

	var file = File.new()

	var full_path = SAVE_FILE_PATH + SAVE_FILE_NAME
	var err = ResourceSaver.save(full_path, save_game)
	if err == OK:
		print("Game saved successfully!")
	else:
		print("Failed to save the game, error code: ", err)
	
var lighthouse_levels = [
	"res://Levels/LightHouseLevels/LighthouseLevel_1.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_2.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_3.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_4.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_5.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_6.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_7.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_8.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_9.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_10.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_11.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_12.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_13.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_14.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_15.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_16.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_17.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_18.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_19.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_20.tscn"
]

var completed_levels = []

func play_random_lighthouse_level():
	var nr_of_levels = lighthouse_levels.size()
	if completed_levels.size() == nr_of_levels:
		# All levels completed! Wow!
		return
	if nr_of_levels <= 1:
		var scene = load(lighthouse_levels[0])
		get_tree().change_scene_to(scene)
		return
	
	var i = randi() % nr_of_levels
	while completed_levels.has(i):
		i = randi() % nr_of_levels
	
	var scene = load(lighthouse_levels[i])
	completed_levels.append(i)
	get_tree().change_scene_to(scene)

func update_best_lighthouse_count():
	if Events.lighthouse_counter > Events.best_lighthouse_counter:
		Events.best_lighthouse_counter = Events.lighthouse_counter
