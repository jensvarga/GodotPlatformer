extends Area2D

func _on_DeathRect_body_entered(body):
	if body is Player:
		body.die()
