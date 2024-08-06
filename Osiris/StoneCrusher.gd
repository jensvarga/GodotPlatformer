extends Path2D

var active = false
onready var activation_timer := $ActivationTimer

func _ready():
	activation_timer.start()
	
func _on_Hittbox_body_entered(body):
	if active:
		AudioManager.play_random_explosion_sound()
		CameraShaker.add_trauma(0.2)
	
	if body is Player:
		body.hurt()
		
	if body is Enemy:
		body.die()

func _on_ActivationTimer_timeout():
	active = true
