extends CPUParticles2D

func _on_Timer_timeout():
	emitting = false

func _on_Timer2_timeout():
	queue_free()
