extends Path2D

func _on_Hittbox_body_entered(body):
	AudioManager.play_random_explosion_sound()
	
	if body is Player:
		body.die()
		
	if body is Enemy:
		body.die()
	

