extends Node2D

func _ready():
	$Sprite.play()

func _on_Sprite_animation_finished():
	queue_free()
