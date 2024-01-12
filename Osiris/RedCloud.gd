extends Path2D

onready var sprite: = $PathFollow2D/Sprite
var fade_speed = 0.5

var fade = false

func _process(delta):
	if not fade: return
		
	sprite.modulate.a += fade_speed * delta * -1
	if sprite.modulate.a <= 0.0:
		queue_free()

func fade_cloud():
	fade = true
