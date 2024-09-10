extends Node2D

func _ready():
	$AnimatedSprite.frame = 0
	$AnimatedSprite.rotation_degrees = rand_range(-360, 360)
	$AnimatedSprite.play()

func _on_AnimatedSprite_animation_finished():
	queue_free()
