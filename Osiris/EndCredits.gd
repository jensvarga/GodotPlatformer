extends Node2D

func _ready():
	AudioManager.play_africa()
	Transition.play_start_transition()
	
func _process(delta):
	if Input.is_action_just_pressed("ui_jump"):
		get_tree().change_scene("res://Levels/Overworld.tscn")
