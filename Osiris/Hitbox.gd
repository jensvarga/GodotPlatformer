extends Area2D

onready var kinematic_body: = $".."

func _on_Hitbox_body_entered(body):
	if body == kinematic_body: return # collision with self
		
	if not kinematic_body is KinematicBody2D:
		if body is Player:
			body.hurt()
		return
			
	if body is Player and kinematic_body.state != kinematic_body.SHELL:
		kinematic_body.attack(body)
		body.hurt()
	#elif body is Enemy and abs(kinematic_body.velocity.x) > 100:
	elif (body is Enemy and
		kinematic_body is Scarabu and
		(kinematic_body.state == kinematic_body.KICKED or 
		kinematic_body.state == kinematic_body.DEAD)):
		body.die()

func on_shot():
	$"..".on_shot()
