extends Area2D

var dropping = false
var velocity = Vector2.ZERO

const PARTICLES = preload("res://RaDeathParticles.tscn")

func _physics_process(delta):
	if dropping:
		velocity.y = 300 * delta
		translate(velocity)

func _on_RaDead_body_entered(body):
	if body is Player:
		return
	AudioManager.play_random_fart()
	AudioManager.play_boom()
	CameraShaker.add_trauma(0.6)
	var part = PARTICLES.instance()
	get_parent().call_deferred("add_child", part)
	part.position = global_position
	queue_free()

func _on_Timer_timeout():
	dropping = true
