extends Area2D

const HIT_PARTICLES = preload("res://ProjectileHitParticles.tscn")
const speed = 400
var velocity = Vector2.ZERO
var direction: int

onready var trail_particles := $TrailParticles

func set_direction(_direction: int):
	direction = _direction
	scale.x = direction

func _ready():
	AudioManager.play_random_shot()
	
func explode():
	leave_trail_particles()
	spawn_hit_particles()
	queue_free()

func _physics_process(delta):
	velocity.x = speed * delta * direction
	translate(velocity)
	
func leave_trail_particles():
	remove_child(trail_particles)
	get_tree().root.get_child(0).add_child(trail_particles)
	trail_particles.emitting = false
	
func spawn_hit_particles():
	var particles = HIT_PARTICLES.instance()
	get_tree().root.get_child(0).add_child(particles)

	particles.position = $Position2D.global_position
	particles.set_facing(direction)

func _on_VisibilityNotifier2D_screen_exited():
	leave_trail_particles()
	queue_free()

func _on_PowerCrookFireball_body_entered(body):
	if body.has_method("on_shot"):
		body.on_shot() 
		explode()
	else:
		explode()

func _on_PowerCrookFireball_area_entered(area):
	if area.collision_layer & (1 << 14) and area is Area2D:
		print("forcefield bounce")

		var collision_shape_node = area.find_node("CollisionShape2D", true, false)
		if collision_shape_node:
			print("CollisionShape2D found")

		# Check if it's a CircleShape2D
		if collision_shape_node.shape is CircleShape2D:
			print("CircleShape2D found")
			
			# Calculate the collision normal
			var collision_normal = (position - area.global_position).normalized()
			print("Collision normal: ", collision_normal)
			
			# Bounce the velocity
			velocity = velocity.bounce(collision_normal)
			print("Velocity after bounce: ", velocity)
			
			# Update direction and scale
			direction = sign(velocity.x)
			scale.x = direction
			return
			
		else:
			print("Collision shape is not a CircleShape2D")
			
	if area.has_method("on_shot"):
		area.on_shot() 
		explode()
	else:
		print("explod")
		explode()
