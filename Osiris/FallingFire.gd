extends Node2D

onready var fire := $FireParticles
onready var burst_fire := $FireParticles2

var velocity = Vector2.ZERO
var falling = true

func _physics_process(delta):
	if falling:
		velocity = 200 * Vector2(0, 1)
		translate(velocity * delta)

func _on_Area2D_body_entered(body):
	if body is Player:
		body.hurt()
	else:
		burst_fire.restart()
		falling = false

func _on_Timer_timeout():
	call_deferred("queue_free")
