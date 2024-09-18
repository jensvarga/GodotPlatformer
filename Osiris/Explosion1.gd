extends AnimatedSprite

func _ready():
	var random_scale = rand_range(0.5, 2)
	scale = Vector2(random_scale, random_scale)
	frame = 0
	play()

func _on_Explosion1_animation_finished():
	queue_free()
