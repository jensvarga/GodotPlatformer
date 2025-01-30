extends Path2D

onready var sprite := $PathFollow2D/AnimatedSprite

var sound_on = false

func _ready():
	sprite.show()

func raise_lava():
	if sound_on:
		CameraShaker.add_trauma(0.2)
		AudioManager.play_low_rumble()
		
func _on_Area2D_body_entered(body):
	if body is Player:
		body.die()

func _on_VisibilityNotifier2D_screen_entered():
	sound_on = true

func _on_VisibilityNotifier2D_screen_exited():
	sound_on = false
