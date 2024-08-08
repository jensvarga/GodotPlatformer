extends Area2D

func on_shot():
	$"../CPUParticles2D".restart()
	$"../CPUParticles2D2".restart()
	$"../CPUParticles2D3".restart()
	$"../CPUParticles2D4".restart()
	$"../CPUParticles2D5".restart()
	$"../AnimatedSprite".hide()
	$CollisionShape2D.set_deferred("disabled", true)
	$"../../DeathTimer".start()
	$"../../AnimationPlayer".stop()
	AudioManager.play_random_fart()
