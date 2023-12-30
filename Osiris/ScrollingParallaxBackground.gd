extends ParallaxBackground

func _process(delta):
	scroll_base_offset -= Vector2(52, 0) * delta
