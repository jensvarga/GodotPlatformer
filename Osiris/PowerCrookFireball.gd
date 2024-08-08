extends Area2D

const HIT_PARTICLES = preload("res://ProjectileHitParticles.tscn")
const speed = 400
var velocity = Vector2.ZERO
var direction: int

func set_direction(_direction: int):
	direction = _direction
	scale.x = direction

func _ready():
	AudioManager.play_random_shot()
	
func explode():
	spawn_hit_particles()
	queue_free()

func _physics_process(delta):
	velocity.x = speed * delta * direction
	translate(velocity)
	
func spawn_hit_particles():
	var particles = HIT_PARTICLES.instance()
	get_tree().root.get_child(0).add_child(particles)
	particles.position = $Position2D.global_position
	particles.set_facing(direction)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_PowerCrookFireball_body_entered(body):
	if body.has_method("on_shot"):
		body.on_shot() 
		explode()
	else:
		explode()

func _on_PowerCrookFireball_area_entered(area):
	if area.has_method("on_shot"):
		area.on_shot() 
		explode()
	else:
		explode()
