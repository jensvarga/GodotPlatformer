extends Path2D

onready var sprite := $PathFollow2D/AnimatedSprite

func _ready():
	pass # Replace with function body.

func swim():
	sprite.animation = "Swim"
