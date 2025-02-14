extends Area2D

func _on_DeathArea_body_entered(body):
	if body is Player:
		body.die()
	if body is Enemy:
		body.die()
	if body is TerrorBird:
		body.die()
