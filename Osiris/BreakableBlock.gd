extends StaticBody2D

func on_shot():
	$Sprite.hide()
	$CollisionShape2D.set_deferred("disabled", true)
	$DestroyTimer.start()
	$CPUParticles2D.restart()
	$CPUParticles2D2.restart()
	CameraShaker.add_trauma(.6)
	AudioManager.play_break()

func _on_DestroyTimer_timeout():
	queue_free()
