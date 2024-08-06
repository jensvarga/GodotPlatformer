extends Enemy

onready var sprite := $AnimatedSprite
onready var hitbox_shape := $Area2D/CollisionPolygon2D
onready var death_timer := $DeathTimer
onready var freeze_timer := $FreezeTimer

export (int) var MOVE_SPEED = 25

var freeze = false

func _ready():
	sprite.animation = "Walk"
	
func _physics_process(delta):
	if dead:
		return
	if freeze:
		return
		
	apply_gravity(delta)
	var found_wall = is_on_wall()
	
	if found_wall:
		direction *= -1
		flip_sprite()
		
	velocity.x = direction.x * MOVE_SPEED
	velocity = move_and_slide(velocity, Vector2.UP)

func apply_gravity(delta):
	velocity.y += gravity * delta
	
func flip_sprite():
	sprite.flip_h = not sprite.flip_h
	
func face(body):
	if body.global_position.x < global_position.x:
		sprite.flip_h = false
	else:
		sprite.flip_h = true

func _on_Area2D_body_entered(body):
	if dead:
		return
	if body is Player:
		if body.velocity.y > 0:
			body.bounce(400)
			dead = true
			sprite.animation = "Die"
			AudioManager.play_random_hit_sound()
			death_timer.start()
		else:
			body.hurt()
			face(body)
			sprite.animation = "Attack"
			freeze = true
			freeze_timer.start()

func _on_DeathTimer_timeout():
	die()

func _on_FreezeTimer_timeout():
	freeze = false
	sprite.animation = "Walk"
