extends Enemy

export (int) var MOVE_SPEED = 25
export (int) var DEATH_BOUNCE = -200

onready var ledgeCheckRight: = $LedgeCheckRight
onready var ledgeCheckLeft: = $LedgeCheckLeft
onready var collision_shape: = $CollisionShape2D
onready var hitbox = $Hitbox
onready var sprite: = $AnimatedSprite
onready var hurt_area_collision: = $HurtArea/CollisionShape2D
onready var hitbox_collision = $Hitbox/CollisionShape2D

var rng = RandomNumberGenerator.new()
var freeze = false

func _physics_process(delta):
	if freeze: return
	if dead:
		spinn_sprite(delta)
		apply_gravity(delta)
		velocity = move_and_slide(velocity, Vector2.UP)
		return
	
	apply_gravity(delta)
	
	var found_wall = is_on_wall()
	var found_ledge_right = not ledgeCheckRight.is_colliding()
	var found_ledge_left = not ledgeCheckLeft.is_colliding()
	var found_ledge = found_ledge_right or found_ledge_left
	
	if found_wall or found_ledge:
		direction *= -1
		flip_sprite()
		
	velocity = direction * MOVE_SPEED

	sprite.animation = "Walk"
	velocity = move_and_slide(velocity, Vector2.UP)

func attack(body):
	face(body)
	sprite.animation = "Attack"
	freeze = true
	
func flip_sprite():
	sprite.flip_h = not sprite.flip_h

func apply_gravity(delta):
	velocity.y += gravity * delta

func spinn_sprite(delta):
	sprite.rotate(delta * deg2rad(360 + random_spinn))

func face(body):
	var direction = -1
	var shell_center_x = global_transform.origin.x + collision_shape.shape.extents.x / 2
	var player_center_x = body.global_transform.origin.x + body.collision_shape.shape.extents.x / 2
	if player_center_x > shell_center_x:
		direction = 1
	
	if (direction > 0 and not sprite.flip_h) or (direction < 0 and sprite.flip_h):
		flip_sprite()

func die():
	if dead: return
	AudioManager.play_random_hit_sound()
	disable_colliders()
	dead = true
	state = DEAD
	sprite.animation = "Dead"
	velocity.y = DEATH_BOUNCE
	random_spinn = rng.randi_range(0, 45)
	
func disable_colliders():
	hitbox_collision.set_deferred("disabled", true)
	hurt_area_collision.set_deferred("disabled", true)
	collision_shape.set_deferred("disabled", true)
			
func _on_Area2D_body_entered(body):
	if body is Scarabu:
		if body.state == body.KICKED:
			die()
