extends Area2D

export (int) var bounce_strenght = 400

onready var enemy: = $".."

func _on_HurtArea_body_entered(body):
	if body is Player:
		body.bounce(bounce_strenght)
		enemy.die()
		
