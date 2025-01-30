extends Node2D

export (float) var lava_speed = 30

onready var lava := $lava
onready var top := $TopPosition
onready var timer := $Timer

var raising = false

func _physics_process(delta):
	if raising:
		if lava.position.y > top.position.y:
			lava.position.y -= lava_speed * delta
		else:
			timer.stop()
			raising = false

func _on_Area2D_body_entered(body):
	if body is Player:
		raising = true
		timer.start()
		AudioManager.play_rumble()
		CameraShaker.add_trauma(0.5)

func _on_Timer_timeout():
	AudioManager.play_low_rumble()
	CameraShaker.add_trauma(0.5)
