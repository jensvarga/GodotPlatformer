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

var phi = (1 + sqrt(5)) / 2  
var growth_rate = phi / (phi * 60 * 60)
var save_file_exists = false
var controls_open = false

func _ready():
	AudioManager.play_main_theme()
	VisualServer.set_default_clear_color(sky_color)
	
	
	if save_file_exists:
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

var initial_scale = Vector2(1, 1)
var target_scale = Vector2(1, 1)

var time_elapsed = 0.0

func _process(delta):
	time_elapsed += delta
	logo.scale += Vector2(growth_rate, growth_rate) * delta
	if not controls_image.visible && controls_open:
		controls_image.show()
	elif controls_image.visible && not controls_open:
		controls_image.hide()
	
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
	continue_button.set_disabled(not save_file_exists)
	for button in main_buttons:
		button.set_disabled(false)
		
	
func _on_Play_pressed():
	get_tree().change_scene(connecting_level_path)

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

func _on_ControlsButton_pressed():
	controls_open = true
	deactivate_options_menu()
