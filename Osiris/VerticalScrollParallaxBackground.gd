extends ParallaxBackground

export (int) var scroll_speed

export (bool) var stopped = false

func _physics_process(delta):
	if not stopped:
		scroll_base_offset += Vector2(0, scroll_speed) * delta
