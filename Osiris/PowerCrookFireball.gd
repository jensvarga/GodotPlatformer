extends Area2D

const HIT_PARTICLES = preload("res://ProjectileHitParticles.tscn")
const FORCE_FIELD = preload("res://ForceField.tscn")
const speed = 400
var velocity = Vector2.ZERO
var direction: int
var root: Node
var can_hurt_self: bool = false

onready var trail_particles := $TrailParticles

func set_direction(_direction: int):
	direction = _direction
	scale.x = direction

func _ready():
	AudioManager.play_random_shot()
	root = get_tree().root.get_child(4)
	
func explode():
	_move_trail_particles()
	spawn_hit_particles()
	call_deferred("queue_free")

func _physics_process(delta):
	velocity.x = speed * delta * direction
	translate(velocity)
	
func _move_trail_particles():
	var parent = trail_particles.get_parent()
	
	if parent == self:
		call_deferred("remove_child", trail_particles)
	
	if parent != root:
		root.call_deferred("add_child", trail_particles)
	trail_particles.position = Vector2(-10000, -10000)
	
func spawn_hit_particles():
	var particles = HIT_PARTICLES.instance()
	root.call_deferred("add_child", particles)
	particles.position = $Position2D.global_position
	particles.set_facing(direction)

func _on_VisibilityNotifier2D_screen_exited():
	_move_trail_particles()
	call_deferred("queue_free")

func _on_PowerCrookFireball_body_entered(body):
	if body.has_method("hurt") and can_hurt_self:
		body.hurt()
		explode()
		return
	if body.has_method("on_shot"):
		body.on_shot() 
		explode()
	else:
		explode()

func _on_PowerCrookFireball_area_entered(area):
	if area.collision_layer & (1 << 14) and area is Area2D:

		var collision_shape_node = area.find_node("CollisionShape2D", true, false)
		if collision_shape_node.shape is CircleShape2D:
	
			var collision_normal = (position - area.global_position).normalized()
			velocity = velocity.bounce(collision_normal)
			direction = sign(velocity.x)
			scale.x = direction
			
			var force_field := FORCE_FIELD.instance()
			area.call_deferred("add_child", force_field)
			force_field.position = area.position
			
			return
			
		else:
			print("Collision shape is not a CircleShape2D")
			
	if area.has_method("on_shot"):
		area.on_shot() 
		explode()
	else:
		explode()

func _on_HurtSelfTimer_timeout():
	can_hurt_self = true
