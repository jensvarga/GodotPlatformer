extends Area2D

var collected = false
onready var sprite := $Sprite

func _on_LeftFoot_body_entered(body):
	if body is Player and not collected:
		sprite.hide()
		AudioManager.play_random_checkpoint_sound()
		Events.emit_signal("stage_cleared")
		call_deferred("queue_free")
