extends StaticBody2D

class_name PitOfDoom

onready var sprite := $Sprite

export (bool) var jump = false

func _process(delta):
	if jump:
		jump = false
		sprite.animation = "RaJumps"
