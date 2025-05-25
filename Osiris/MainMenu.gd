extends Control
class_name MainMenu

export (String, FILE, "*.tscn") var connecting_level_path = "res://Levels/OverworldLevel.tscn"
export (Color) var sky_color = Color.deepskyblue

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
onready var toggle_fullscreen_timer := $ToggleFullscreenTimer

var toggle_delay = false

var phi = (1 + sqrt(5)) / 2  
var growth_rate = phi / (phi * 60 * 60)
var controls_open = false

func _ready():
	Events.connect("updated_fullscreen", self, "_on_updated_fullscreen")
	SaveManager.load_settings()
	AudioManager.play_main_theme()
	VisualServer.set_default_clear_color(sky_color)
	
	if SaveManager.save_exists():
		continue_button.disabled = false
	else:
		continue_button.disabled = true
	
	if SaveManager.save_exists():
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
	fullscreen_checkbox.pressed = Events.fullscreen

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
	continue_button.set_disabled(not SaveManager.save_exists())
	for button in main_buttons:
		button.set_disabled(false)

func _on_Options_pressed():
	activate_options_menu()

func _on_Exit_pressed():
	get_tree().call_deferred("quit")

func _on_Back_pressed():
	deactivate_options_menu()

func _on_Music_pressed():
	music_checkbox.pressed = not music_checkbox.pressed
	Events.emit_signal("toggle_music")

func _on_Fx_pressed():
	fx_checkbox.pressed = not fx_checkbox.pressed
	Events.emit_signal("toggle_sound_effects")

func _on_Fullscreen_pressed():
	if toggle_delay:
		return
	Events.emit_signal("toggle_fullscreen")
	fullscreen_button.call_deferred("grab_focus")
	toggle_fullscreen_timer.start()
	toggle_delay = true

func _on_updated_fullscreen():
	fullscreen_checkbox.pressed = Events.fullscreen


func _on_ControlsButton_pressed():
	controls_open = true
	deactivate_options_menu()

func _on_Continue_pressed():
	print("Continue pressed")
	
	if not SaveManager.save_exists():
		print("Could not find saved game")
		return

	SaveManager.load_game()
	Transition.hide_background()
	get_tree().change_scene(connecting_level_path)

func load_saved_settings():
	SaveManager.load_settings()
	
func _on_NewGame_pressed():
	SaveManager.erase_save()
	SaveManager.reset_data()
	
	Transition.hide_background()
	get_tree().change_scene(connecting_level_path)

func _on_FFM_pressed():
	toggle_ffm()

func toggle_ffm():
	if Events.family_friendly_mode:
		Events.family_friendly_mode = false
	else:
		Events.family_friendly_mode = true
	
	ffm_checkbox.pressed = Events.family_friendly_mode
	SaveManager.save_settings()

func save_settings():
	pass

func _on_ToggleFullscreenTimer_timeout():
	toggle_delay = false
