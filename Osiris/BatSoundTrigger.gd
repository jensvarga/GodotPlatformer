extends Area2D

var playing = false
onready var timer := $Timer

func _ready():
	pass

func _on_BatSoundTrigger_body_entered(body):
	if not playing:
		AudioManager.play_bat_swarm()
		playing = true
		timer.start()

func _on_Timer_timeout():
	playing = false
