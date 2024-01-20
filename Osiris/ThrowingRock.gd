extends RigidBody2D

func instanciate(new_position, throw_dir, added_velocity):
	global_position = Vector2(new_position.x + throw_dir.x * 25, new_position.y)
	apply_central_impulse(added_velocity)

func destroy():
	AudioManager.play_random_explosion_sound()
	queue_free()
		
func _on_Area2D_body_entered(body):
	if body is Player:
		body.die()
	elif body is Boss:
		body.hurt()
		destroy()
	elif body.get_collision_layer() == 1:
		destroy()

