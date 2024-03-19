extends Area2D

onready var particles := $CPUParticles2D

func _on_Bubbles_body_entered(body):
	if body is Turtle:
		particles.emitting = true
