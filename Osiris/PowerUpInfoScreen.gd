extends Control

var visable = false

func initialize(title, description, key_binding, image, description_image):
	var title_label := $MarginContainer/ColorRect/VBoxContainer/HBoxContainer2/TitleLabel
	var description_label := $MarginContainer/ColorRect/VBoxContainer/HBoxContainer/DescriptionLabel
	var description_texture := $MarginContainer/ColorRect/VBoxContainer/HBoxContainer3/DescriptionTexture
	var item_texture := $MarginContainer/ColorRect/VBoxContainer/HBoxContainer2/TextureRect
	var input := $MarginContainer/ColorRect/VBoxContainer/HBoxContainer/InputLabel
	
	title_label.text = title
	input.text = get_button(key_binding).trim_suffix(" (Physical)")
	description_label.text = description
	description_texture.texture = description_image
	item_texture.texture = image
	
	Events.player.hide()
	visable = true
	get_parent().get_tree().paused = true

func _input(event):
	if (event.is_action_released("ui_cancel") or event.is_action_pressed("ui_jump")) and visable:
		accept_event()
		get_parent().get_tree().paused = false
		Events.player.show()
		visable = false
		hide()

func get_button(action: String) -> String:
	var events = InputMap.get_action_list(action)

	for event in events:
		if event is InputEventKey:
			return event.as_text()
			
	return ""
