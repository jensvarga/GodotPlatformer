extends Node2D

onready var clear_timer := $ClearTimer

func _ready():
	Events.has_power_crook = true
	Events.has_talaria = true

func _on_OsirisShaftTrigger_body_entered(body):
	if body is Player:
		Transition.flash_name("The Osiris Shaft")

func _on_MusicTrigger_body_entered(body):
	if body is Player:
		AudioManager.fade_music()
		AudioManager.play_low_rumble()

func _on_BumpTrigger_body_entered(body):
	if body is Player:
		AudioManager.play_boom()
		CameraShaker.add_trauma(0.5)
		$BumpTrigger/CollisionShape2D.set_deferred("disabled", true)
		clear_timer.start()

func _on_ClearTimer_timeout():
	Events.emit_signal("stage_cleared")
