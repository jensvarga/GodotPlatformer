extends Node2D

export (float) var travel_time = 1

onready var start_pos := $Start
onready var end_pos := $End
onready var platform := $KinematicBody2D
onready var tween := $Tween

func _ready():
	platform.position = start_pos.position
	flip_direction()

func flip_direction():
	if platform.position == start_pos.position:
		tween.interpolate_property(platform, "position", platform.position, end_pos.position, travel_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		tween.start()
	elif platform.position == end_pos.position:
		tween.interpolate_property(platform, "position", platform.position, start_pos.position, travel_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		tween.start()

func _on_Tween_tween_all_completed():
	flip_direction()
