extends Control
class_name MainMenu

export (String, FILE, "*.tscn") var connecting_level_path = "res://Levels/OverworldLevel.tscn"
export (Color) var sky_color = Color.deepskyblue

# Save Data
const SAVE_FILE_PATH := "user://save/"
const SAVE_FILE_NAME := "SaveGame.tres"
const SETTINGS_FILE_NAME := "Settings.tres"

var save_game = SaveGame.new()
var save_settings = SaveSettings.new()

onready var logo := $AspectRatioContainer/Logo
onready var new_button := $MarginContainer/Control/Hbox/Vbox/NewGame
onready var continue_button := $MarginContainer/Control/Hbox/Vbox/Continue
onready var fullscreen_button := $MarginContainer/Control/Hbox/VBoxContainer/FullscreenHbox/Fullscreen
onready var exit_button := $MarginContainer/Control/Hbox/Vbox/Exit
onready var options_menu := $MarginContainer/Control/Hbox/VBoxContainer
onready var fullscreen_checkbox := $MarginContainer/Control/Hbox/VBoxContainer/FullscreenHbox/CheckBox
onready var music_checkbox := $MarginContainer/Control/Hbox/VBoxContainer/MusicHBox/CheckBox
onready var fx_checkbox := $MarginContainer/Control/Hbox/VBoxContainer/FxHBox/CheckBox
onready var main_buttons := [\
$MarginContainer/Control/Hbox/Vbox/NewGame,\
$MarginContainer/Control/Hbox/Vbox/Options,\
$MarginContainer/Control/Hbox/Vbox/Exit\
]
onready var controls_image := $ControlsImage
onready var action_input_control := $ActionMapControl
onready var menu := $MarginContainer
onready var actions_list := $ActionMapControl/PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/ActionList
onready var options_button := $MarginContainer/Control/Hbox/Vbox/Options
onready var ffm_checkbox := $MarginContainer/Control/Hbox/VBoxContainer/FFMBox/CheckBox

var phi = (1 + sqrt(5)) / 2  
var growth_rate = phi / (phi * 60 * 60)
var controls_open = false

func _ready():
	verify_save_directory(SAVE_FILE_PATH)
	load_saved_settings()
	AudioManager.play_main_theme()
	VisualServer.set_default_clear_color(sky_color)
	
	print("save exitist: ", save_game_exists())
	if save_game_exists():
		continue_button.disabled = false
	else:
		continue_button.disabled = true
	
	if save_game_exists():
		continue_button.grab_focus()
	else:
		new_button.grab_focus()
		new_button.focus_neighbour_top = NodePath("../Exit")
		new_button.focus_previous = NodePath("../Exit")
		exit_button.focus_neighbour_bottom = NodePath("../NewGame")
		exit_button.focus_next = NodePath("../NewGame")

	options_menu.hide()
	VisualServer.set_default_clear_color(Color.black)
	Transition.skip_animation()
	ffm_checkbox.pressed = Events.family_friendly_mode

var initial_scale = Vector2(1, 1)
var target_scale = Vector2(1, 1)

var time_elapsed = 0.0

func _process(delta):
	time_elapsed += delta
	logo.scale += Vector2(growth_rate, growth_rate) * delta
	if not action_input_control.visible && controls_open:
		action_input_control.show()
		var actions = actions_list.get_children()
		actions[0].grab_focus()
		menu.hide()
	elif action_input_control.visible && not controls_open:
		action_input_control.hide()
		options_button.grab_focus()
		menu.show()

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
	
func save_game_exists() -> bool:
	var file = File.new()
	var full_path = SAVE_FILE_PATH + SAVE_FILE_NAME
	return file.file_exists(full_path)

func save_settings_exists() -> bool:
	var file = File.new()
	var full_path = SAVE_FILE_PATH + SETTINGS_FILE_NAME
	return file.file_exists(full_path)
	
func _input(event):
	if event.is_action_released("ui_cancel") && controls_open:
		controls_open = false
		
func activate_options_menu():
	options_menu.show()
	fullscreen_button.grab_focus()
	continue_button.set_disabled(true)
	for button in main_buttons:
		button.set_disabled(true)
	
func deactivate_options_menu():
	new_button.grab_focus()
	options_menu.hide()
	continue_button.set_disabled(not save_game_exists())
	for button in main_buttons:
		button.set_disabled(false)
		

func _on_Options_pressed():
	activate_options_menu()

func _on_Exit_pressed():
	get_tree().quit()

func _on_Back_pressed():
	deactivate_options_menu()

func _on_Music_pressed():
	music_checkbox.pressed = not music_checkbox.pressed
	Events.emit_signal("toggle_music")

func _on_Fx_pressed():
	fx_checkbox.pressed = not fx_checkbox.pressed
	Events.emit_signal("toggle_sound_effects")

func _on_Fullscreen_pressed():
	fullscreen_checkbox.pressed = not fullscreen_checkbox.pressed
	Events.emit_signal("toggle_fullscreen")
	fullscreen_button.call_deferred("grab_focus")

func _on_ControlsButton_pressed():
	controls_open = true
	deactivate_options_menu()

func _on_Continue_pressed():
	if not save_game_exists(): return
	
	var full_path = SAVE_FILE_PATH + SAVE_FILE_NAME
	save_game = ResourceLoader.load(full_path).duplicate(true)
	load_event_data(save_game)
	get_tree().change_scene(connecting_level_path)

func load_event_data(data: Resource):
	if data != null:
		Events.death_counter = int(data.death_counter)
		Events.collected_items = Array(data.collected_items)
		Events.player_hit_points = int(data.player_hit_points)
		Events.has_power_crook = bool(data.has_power_crook)
		Events.has_talaria = bool(data.has_talaria)
		Events.lives = int(data.lives)
		Events.has_left_hand = bool(data.has_left_hand)
		Events.has_right_hand = bool(data.has_right_hand)
		Events.has_pen15 = bool(data.has_pen15)
		Events.has_head = bool(data.has_head)
		Events.has_left_foot = bool(data.has_left_foot)
		Events.has_right_foot = bool(data.has_right_foot)
		Events.has_torso = bool(data.has_torso)
		Events.player_overworld_position = Vector2(data.player_overworld_position)
		Events.ra_in_cave = bool(data.ra_in_cave)
		Events.ra_has_jumped = bool(data.ra_has_jumped)
		Events.levels_cleared = Dictionary(data.levels_cleared)

func load_saved_settings():
	if not save_settings_exists(): return
	var full_path = SAVE_FILE_PATH + SETTINGS_FILE_NAME
	save_settings = ResourceLoader.load(full_path).duplicate(true)
	if save_settings != null:
		Events.family_friendly_mode = bool(save_settings.family_friendly_mode)
	
func _on_NewGame_pressed():
	var new_game_data = SaveGame.new()
	load_event_data(new_game_data)
	get_tree().change_scene(connecting_level_path)

func _on_FFM_pressed():
	toggle_ffm()

func toggle_ffm():
	if Events.family_friendly_mode:
		Events.family_friendly_mode = false
	else:
		Events.family_friendly_mode = true
	
	ffm_checkbox.pressed = Events.family_friendly_mode
	save_settings()

func save_settings():
	verify_save_directory(SAVE_FILE_PATH)
	var save_settings = SaveSettings.new()
	save_settings.family_friendly_mode = Events.family_friendly_mode

	var full_path = SAVE_FILE_PATH + SETTINGS_FILE_NAME
	var err = ResourceSaver.save(full_path, save_settings)
	if err == OK:
		print("Settings saved successfully!")
	else:
		print("Failed to save the settings, error code: ", err)
