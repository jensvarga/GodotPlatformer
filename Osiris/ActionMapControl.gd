extends Control

const SAVE_FILE_PATH := "user://custom_input/"
const SAVE_FILE_NAME := "CustomInputMap.tres"
const INPUT_BUTTON = preload("res://InputButton.tscn")

onready var action_list_gui = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/ActionList

var is_remapping = false
var action_to_remap = null
var remapping_button = null

var custom_input_map: CustomInputMap = null
var action_list = {
	"move_left": [create_input_event_key(KEY_LEFT)],
	"move_right": [create_input_event_key(KEY_RIGHT)],
	"look_up": [create_input_event_key(KEY_UP)],
	"look_down": [create_input_event_key(KEY_DOWN)],
	"ui_jump": [create_input_event_key(KEY_A)],
	"ui_fire": [create_input_event_key(KEY_S)],
	"ui_grab": [create_input_event_key(KEY_X)]
}

var input_actions = {
	"move_left" : "Left",
	"move_right" : "Right",
	"look_up" : "Look Up",
	"look_down" : "Crouch",
	"ui_jump" : "Primary Action",
	"ui_fire" : "Secondary Action",
	"ui_grab" : "Tertiary Action"
}

func _ready():
	Events.verify_save_directory(SAVE_FILE_PATH)
	load_custom_inputs()
	_create_action_list()
	update_input()

func update_input():
	for action in input_actions.keys():
		InputMap.action_erase_events(action)

		var events = action_list[action]
		for event in events:
			InputMap.action_add_event(action, event)

func create_input_event_key(scancode: int) -> InputEventKey:
	var event = InputEventKey.new()
	event.scancode = scancode
	return event
		
func load_custom_inputs():
	var full_path = SAVE_FILE_PATH + SAVE_FILE_NAME
	var loaded_map = ResourceLoader.load(full_path)

	if loaded_map != null:
		custom_input_map = loaded_map as CustomInputMap
		
		if custom_input_map != null:
			action_list = custom_input_map.action_list
			update_input()
		else:
			print("Error: Loaded resource is not of type CustomInputMap.")
	else:
		print("No custom input map found, using default controls.")


func load_data(data: CustomInputMap):
	if data != null:
		action_list = data.action_list

func _on_button_pressed(action, button):
	if is_remapping:
		return

	is_remapping = true
	action_to_remap = action
	remapping_button = button

	var input_label: Label = remapping_button.get_node("MarginContainer/HBoxContainer/LabelInput")
	input_label.text = "Press a key..."

func _input(event):
	if is_remapping and event is InputEventKey and event.pressed:
		is_remapping = false

		InputMap.action_erase_events(action_to_remap)
		InputMap.action_add_event(action_to_remap, event)

		# Update the action_list dictionary
		action_list[action_to_remap] = [event]

		# Update the label on the remapping button
		var input_label: Label = remapping_button.get_node("MarginContainer/HBoxContainer/LabelInput")
		input_label.text = event.as_text().trim_suffix(" (Physical)")

		action_to_remap = null
		remapping_button = null
		
		accept_event()
		save_custom_input()

func save_custom_input():
	Events.verify_save_directory(SAVE_FILE_PATH)

	var custom_input = CustomInputMap.new()

	custom_input.action_list = action_list
	var full_path = SAVE_FILE_PATH + SAVE_FILE_NAME
	var err = ResourceSaver.save(full_path, custom_input)
	
	if err == OK:
		print("Input map saved successfully!")
	else:
		print("Failed to save the input map, error code: ", err)

func _create_action_list():
	for item in action_list_gui.get_children():
		item.queue_free()

	for action in input_actions.keys():
		var button = INPUT_BUTTON.instance()
		var action_label: Label = button.get_node("MarginContainer/HBoxContainer/LabelAction")
		var input_label: Label = button.get_node("MarginContainer/HBoxContainer/LabelInput")

		action_label.text = input_actions[action]

		var events = InputMap.get_action_list(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = "None"
		
		# Connect the button signal to allow remapping
		button.connect("pressed", self, "_on_button_pressed", [action, button])
		# Add the button to the list
		action_list_gui.add_child(button)
