extends Area2D

class_name ParoMissile

const PARTICLES = preload("res://BennyFireballParticles.tscn")
const SPEED = 300.0

var direction = Vector2.ZERO
var velocity = Vector2.ZERO
var angular_velocity = 0
var heat_seaking = false

func _ready():
	Events.connect("boss_died", self, "_on_boss_died")
	
func set_direction(_direction: Vector2, _rotation: float):
	direction = _direction.normalized()
	rotation = _rotation

func _physics_process(delta):
	var angle_change = angular_velocity * delta
	direction = direction.rotated(angle_change)
	velocity = SPEED * direction

	translate(velocity * delta)
	rotation = direction.angle()

func spawn_particles():
	var particles = PARTICLES.instance()
	particles.position = global_position
	get_parent().call_deferred("add_child", particles)

func _on_VisibilityNotifier2D_screen_exited():
	call_deferred("queue_free")

func _on_Timer_timeout():
	spawn_particles()
	call_deferred("queue_free")

func _on_ParoMissile_body_entered(body):
	if body is Player:
		CameraShaker.add_trauma(0.4)
		body.hurt()
		spawn_particles()
		call_deferred("queue_free")

func _on_boss_died():
	spawn_particles()
	call_deferred("queue_free")
