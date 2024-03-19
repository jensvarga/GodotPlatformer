extends KinematicBody2D
class_name Turtle

onready var tween := $"../Tween"
onready var follow := $".."

var sunk = false
func sink():
	if !sunk:
		AudioManager.play_trumpet()
		tween.interpolate_property(follow, "v_offset", 0, 50, 1)
		tween.start()
		sunk = true
