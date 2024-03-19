extends Area2D

export (int) var LERP_TARGET

onready var camera := $"../PlayerRoot/Anchor/Camera2D"
var lerp_factor := 1.0
var lerp_speed := 0.8
var lerp_from = -400

var entered = false

func _process(delta):
	if lerp_factor < 1.0:
		lerp_factor += lerp_speed * delta
		camera.limit_top = lerp(lerp_from, LERP_TARGET, lerp_factor)
	else:
		lerp_factor = 1.0
		entered = false

func _on_CameraTrigger_body_entered(body):
	if body is Player:
		if not entered:
			entered = true
			lerp_from = camera.limit_top
			lerp_factor = 0.0

func _on_CameraTrigger_body_exited(body):
	if body is Player:
		entered = false
