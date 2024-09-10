extends AnimatedSprite

func _on_Area2D_body_entered(body):
	if body is Player:
		body.die()
	if body is Enemy:
		body.die()
	if body is TerrorBird:
		body.die()
