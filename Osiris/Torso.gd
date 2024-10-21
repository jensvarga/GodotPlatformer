extends Node2D

var collected = false

onready var sprite := $Sprite

func _on_Area2D_body_entered(body):
	if body is Player and not collected:
		sprite.hide()
		Events.has_torso = true
		AudioManager.play_random_checkpoint_sound()
		Events.emit_signal("stage_cleared")
		queue_free()
