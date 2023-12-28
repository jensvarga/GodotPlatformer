extends Area2D

export (int) var bounce_strenght = 230

onready var kinematic_body = $".."
onready var collision_shape = $"../CollisionShape2D"

func _on_HurtBox_body_entered(body):
	if body is Player:
		
		match kinematic_body.state:
			kinematic_body.MOVE:
				body.bounce(bounce_strenght)
				kinematic_body.enter_shell()
			kinematic_body.SHELL:
				body.bounce(bounce_strenght)
				var direction = 1
				var shell_center_x = global_transform.origin.x + collision_shape.shape.extents.x / 2
				var player_center_x = body.global_transform.origin.x + body.collision_shape.shape.extents.x / 2
				if player_center_x > shell_center_x:
					direction = -1
					
				kinematic_body.enter_kicked(direction)
			kinematic_body.KICKED:
				body.bounce(bounce_strenght)
				kinematic_body.enter_shell()
