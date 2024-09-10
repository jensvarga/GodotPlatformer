extends Area2D

func _on_MusicStopper_body_entered(body):
	if body is Player:
		AudioManager.stop_music()
		queue_free()
