extends RigidBody2D

func _on_Area2D_body_entered(body):
	if body is Turtle:
		AudioManager.play_pop()
		body.sink()
		queue_free()
	if body is Player:
		body.hurt()
	if body is Enemy:
		body.die()
