extends Sprite

export(float) var flicker_speed = 6.0
export(float) var min_alpha = 0.9
export(float) var max_alpha = 1.0
export(float) var random_intensity = 0.1

func _process(delta):
	var flicker = (sin(2.0 * PI * flicker_speed * OS.get_ticks_msec() / 1000.0) + 1.0) / 2.0
	flicker = lerp(min_alpha, max_alpha, flicker)
	
	flicker += (randf() * 2.0 - 1.0) * random_intensity
	flicker = clamp(flicker, min_alpha, max_alpha)
	modulate.a = flicker
