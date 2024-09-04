extends Node2D

onready var sprite = $AnimatedSprite

func set_animation(animation: String, direction: int):
	sprite.animation = animation
	
	match animation:
		"Effect1":
			sprite.rotation_degrees = 90.0
			sprite.offset.y = -30
			sprite.offset.x = 0
			
			if direction < 0:
				sprite.offset.y = 30
				sprite.flip_v = true
		"Effect2":
			sprite.rotation_degrees = 0.0
			sprite.offset.x = 30
			sprite.offset.y = 11
			
			if direction < 0:
				sprite.offset.x = -30
				sprite.flip_h = true
		"Effect3":
			sprite.rotation_degrees = 0.0
			sprite.offset.y = 0
			sprite.offset.x = 20
			
			if direction < 0:
				sprite.offset.x = -20
				sprite.flip_h = true
	
	sprite.frame = 0
	sprite.play()

func _on_AnimatedSprite_animation_finished():
	queue_free()
