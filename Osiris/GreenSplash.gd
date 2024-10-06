extends AnimatedSprite

func _ready():
	frame = 0
	playing = true
	print("started")
	
func _on_GreenSplash_animation_finished():
	queue_free()
