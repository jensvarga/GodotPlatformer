extends Node

const SAVE_FILE_PATH := "user://save/"
const SAVE_FILE_NAME := "SaveGame.res"

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
signal heal_boss
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
signal update_ankhs
signal returned_body

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
var lighthouse_level_boss: bool = false

var has_ressurected_osiris = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Events.connect("player_died", self, "_on_player_died")
	Events.connect("toggle_fullscreen", self, "_on_toggle_fullscreen")
	Events.connect("toggle_music", self, "_on_toggle_music")
	Events.connect("toggle_sound_effects", self, "_on_toggle_sound_effects")
	Events.connect("player_take_damage", self, "_on_player_take_damage")
	Events.connect("pick_up_ankh", self, "_on_pick_up_ankh")
	Events.connect("damage_boss", self, "_on_damage_boss")
	Events.connect("heal_boss", self, "_on_heal_boss")
	Events.connect("pick_up_power_crook", self, "_on_pick_up_power_crook")
	Events.connect("gained_life", self, "on_gained_life")
	Events.connect("ra_jumped", self, "_on_ra_jumped")
	Events.connect("pick_up_talaria", self, "_on_pick_up_talaria")
	Transition.connect("pixelation_completed", self, "_on_pixelation_completed")

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
	
	emit_signal("update_ankhs")

func _on_pick_up_ankh():
	if player_hit_points + 1 >= max_player_hit_points:
		player_hit_points = max_player_hit_points
	else:
		player_hit_points = player_hit_points + 1
	Events.emit_signal("pick_up_power_up")
		
func _on_player_died():
	player = null
	death_counter += 1
	if Events.lighthouse_level or Events.lighthouse_level_boss:
		return
	if (lives - 1) <= 0:
		lives = 0
	else:
		lives = lives - 1
	player_hit_points = max_player_hit_points
	
func _on_toggle_fullscreen():
	OS.window_fullscreen = !OS.window_fullscreen
	SaveManager.save_settings()

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

func _on_heal_boss():
	if boss_hit_points + 1 >= 12:
		pass
	else:
		if boss_hit_points < 6:
			boss_hit_points = boss_hit_points + 2
		elif boss_hit_points < 2:
			boss_hit_points = boss_hit_points + 3
		else:
			boss_hit_points = boss_hit_points + 1

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

func save_game_data():
	SaveManager.save_game()

func eraze_saved_game():
	SaveManager.erase_save()
	
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
	"res://Levels/LightHouseLevels/LighthouseLevel_20.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_21.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_22.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_23.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_24.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_25.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_26.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_27.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_28.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_29.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_30.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_31.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_32.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_33.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_34.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_35.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_36.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_37.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_38.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_39.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_40.tscn",
	"res://Levels/LightHouseLevels/LighthouseLevel_41.tscn"
]

var final_lighthouse_level := "res://Levels/LightHouseLevels/LighthouseSummit.tscn"

var completed_levels = []

func play_random_lighthouse_level():
	var nr_of_levels = lighthouse_levels.size()
	if completed_levels.size() == nr_of_levels:
		var final_level = load(final_lighthouse_level)
		get_tree().change_scene_to(final_level)
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

#### --------------------------------

func continue_game():
	var overworld_path := "res://Levels/OverworldLevel.tscn"
	check_point_reached = false
	lives = 3
	get_tree().change_scene(overworld_path)

func dont_continue():
	var main_menu_path := "res://MainMenu.tscn"
	eraze_saved_game()
	get_tree().change_scene(main_menu_path) 

func launch_continue_screen():
	var CONTINTUE_SCEEN_PATH := "res://ContinueScreen.tscn"
	get_tree().change_scene(CONTINTUE_SCEEN_PATH)

func _on_pixelation_completed():
	if lives == 1:
		launch_continue_screen()
