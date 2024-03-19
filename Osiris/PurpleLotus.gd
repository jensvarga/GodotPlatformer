extends StaticBody2D

onready var sprite := $AnimatedSprite
onready var particles := $CPUParticles2D
onready var timer := $Timer

func _on_Area2D_body_entered(body):
	if body is Player:
		body.bounce(500)
		AudioManager.play_random_checkpoint_sound()
		sprite.animation = "Pop"
		particles.emitting = true
		timer.start()

func _on_Timer_timeout():
	Events.emit_signal("stage_cleared")
