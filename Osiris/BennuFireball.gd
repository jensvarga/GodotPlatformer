extends Area2D

const PARTICLES = preload("res://BennyFireballParticles.tscn")

const SPEED = 200.0
var direction = Vector2.ZERO
var velocity = Vector2.ZERO
var angular_velocity = 0

func set_direction(_direction: Vector2, _rotation: float, _angular_velocity):
	direction = _direction.normalized()
	rotation = _rotation
	angular_velocity = _angular_velocity

func _physics_process(delta):
	var angle_change = angular_velocity * delta
	direction = direction.rotated(angle_change)
	velocity = SPEED * direction

	translate(velocity * delta)
	rotation = direction.angle()

func spawn_particles():
	var particles = PARTICLES.instance()
	particles.position = global_position
	get_parent().add_child(particles)
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_BennuFireball_body_entered(body):
	if body is Player:
		body.hurt()
		spawn_particles()
	
	if (body.get_collision_layer() & (1 << 0)) != 0:
		spawn_particles()
		
func _on_Timer_timeout():
	spawn_particles()
	queue_free()
