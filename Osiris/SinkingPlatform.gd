extends Node2D

export (float) var travel_time = 1
export (Vector2) var target_position 

onready var platform := $KinematicBody2D
onready var tween := $Tween

var start_pos = Vector2.ZERO
var on_block = false

func flip_direction():
	tween.stop_all()
	if on_block:
		tween.interpolate_property(platform, "position", platform.position, target_position, travel_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		tween.start()
	else:
		tween.interpolate_property(platform, "position", platform.position, start_pos, travel_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		tween.start()

func _on_Tween_tween_all_completed():
	flip_direction()

func _on_TriggerArea_body_entered(body):
	if body is Player:
		on_block = true
		flip_direction()

func _on_TriggerArea_body_exited(body):
	if body is Player:
		on_block = false
		flip_direction()
