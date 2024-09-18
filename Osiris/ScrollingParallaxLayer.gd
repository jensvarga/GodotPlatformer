extends ParallaxLayer

export var scroll_speed: float = 100.0

export var direction: int = 1

func _process(delta: float):
	var current_offset = motion_offset
	current_offset.x += scroll_speed * direction * delta
	motion_offset = current_offset
