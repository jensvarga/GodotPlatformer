extends Area2D

onready var left_door := $Level1BossDoor
onready var exit_timer := $ExitTimer

func _ready():
	pass

func _on_BossTrigger_body_entered(body):
	if body is Player:
		left_door.close = true
		exit_timer.start()
		AudioManager.fade_music()
		
func _on_ExitTimer_timeout():
	Events.emit_signal("stage_cleared")
