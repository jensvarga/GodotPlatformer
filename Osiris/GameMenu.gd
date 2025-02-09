extends Node2D

onready var menu_control := $Control
onready var return_button := $Control/Vbox/Return
onready var lapis_count := $Control/LapisCounter
onready var lapis_sprite := $Control/Lapis

var main_menu_path = "res://MainMenu.tscn"
var overworld_path = "res://Levels/OverworldLevel.tscn"

const SAVE_FILE_PATH := "user://save/"
const SAVE_FILE_NAME := "SaveGame.tres"

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
	update_lapis_count()
	
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

func update_lapis_count():
	if not is_instance_valid(lapis_sprite) or not is_instance_valid(lapis_count):
		return
		
	var elements = Events.lapis_ids.size()
	if elements <= 0:
		lapis_sprite.hide()
		lapis_count.text = ""
	else:
		lapis_sprite.show()
		lapis_count.text = " x " + (elements as String)
	
func _on_Return_pressed():
	return_to_game()

func _on_Restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_Exit_pressed():
	get_tree().paused = false
	exit_level()
	Events.save_game_data()
	get_tree().change_scene(overworld_path)

func _on_MainMenu_pressed():
	get_tree().paused = false
	exit_level()
	Events.save_game_data()
	get_tree().change_scene(main_menu_path)
