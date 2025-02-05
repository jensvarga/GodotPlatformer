extends Area2D

func _on_DeathArea2D_body_entered(body):
	if body is Player:
		body.die()
