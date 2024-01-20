extends ParallaxBackground

export (int) var scroll_speed

func _process(delta):
	scroll_base_offset -= Vector2(scroll_speed, 0) * delta
