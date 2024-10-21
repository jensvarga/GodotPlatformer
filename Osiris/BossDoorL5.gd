extends Node2D

onready var blocker := $KinematicBody2D/CollisionShape2D
onready var tween := $Tween
onready var sprite := $Sprite
onready var trigger_area := $TriggerArea

func _on_TriggerArea_body_entered(body):
	if body is Player:
		blocker.set_deferred("disabled", false)
		tween.interpolate_property(sprite, "position:y", sprite.position.y, 67.0, Tween.TRANS_SINE, Tween.EASE_OUT)
		tween.start()
		trigger_area.queue_free()

func _on_Tween_tween_all_completed():
	CameraShaker.add_trauma(.5)
	AudioManager.play_boom()
	$Timer.start()

func _on_Timer_timeout():
	Events.emit_signal("stage_cleared")
