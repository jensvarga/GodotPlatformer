extends AnimatedSprite

func _ready():
	frame = 0
	playing = true
	
func _on_GreenSplash_animation_finished():
	queue_free()

func set_blue():
	modulate = Color("2d98ff")
