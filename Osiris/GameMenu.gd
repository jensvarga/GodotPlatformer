extends Node2D

onready var menu_control := $Control
onready var return_button := $Control/Vbox/Return

var main_menu_path = "res://MainMenu.tscn"
var overworld_path = "res://Levels/OverworldLevel.tscn"

var menu_active = false

func _ready():
	menu_control.hide()
	menu_active = false
	
func _input(event):
	if event.is_action_released("ui_cancel"):
		if not menu_active:
			activate_game_menu()
		else:
			return_to_game()
	
func activate_game_menu():
	return_button.grab_focus()
	menu_control.show()
	menu_active = true
	get_tree().paused = true
	
func return_to_game():
	menu_control.hide()
	menu_active = false
	var button_with_focus = menu_control.get_focus_owner()
	if button_with_focus != null:
		button_with_focus.release_focus()
	get_tree().paused = false
	
func exit_level():
	AudioManager.stop_music()
	Events.check_point_reached = false
	
func _on_Return_pressed():
	return_to_game()

func _on_Restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_Exit_pressed():
	get_tree().paused = false
	exit_level()
	get_tree().change_scene(overworld_path)

func _on_MainMenu_pressed():
	get_tree().paused = false
	exit_level()
	get_tree().change_scene(main_menu_path)
