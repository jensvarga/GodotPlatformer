extends RigidBody2D

func _destroy():
	call_deferred("queue_free")

func _on_Area2D_body_entered(body):
	if body is Player:
		body.hurt()
		_destroy()

func _on_VisibilityNotifier2D_screen_exited():
	call_deferred("queue_free")
