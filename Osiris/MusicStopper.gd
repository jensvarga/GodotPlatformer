extends Area2D

func _on_MusicStopper_body_entered(body):
	if body is Player:
		AudioManager.fade_music()
		queue_free()
