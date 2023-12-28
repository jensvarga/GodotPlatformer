extends Area2D

onready var kinematic_body: = $".."

func _on_Hitbox_body_entered(body):
	if not kinematic_body is KinematicBody2D:
		if body is Player:
			body.die()
		return
			
	if body is Player and kinematic_body.state != kinematic_body.SHELL:
		body.die()
	elif body is Enemy and kinematic_body.state == kinematic_body.KICKED:
		body.die()
