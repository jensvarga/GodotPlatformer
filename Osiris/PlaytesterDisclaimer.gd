extends Node2D

export (String, FILE, "*.tscn") var next_scene_path

func _ready():
	Events.emit_signal("toggle_fullscreen")
	Transition.skip_animation()

func _input(event):
	if event.is_action_released("ui_accept"):
		get_tree().change_scene(next_scene_path)

