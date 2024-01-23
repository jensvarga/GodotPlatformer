extends Enemy

var MOVE_SPEED = 40
var freeze = false
var has_hit_wall = false

onready var sprite: = $AnimatedSprite
onready var remove_timer := $RemoveTimer

func _ready():
	direction.x *= scale.x

func _physics_process(delta):
	if freeze: return
	if dead:
		sprite.animation = "Dead"
		apply_gravity(delta)
		velocity = move_and_slide(velocity, Vector2.UP)
		return
		
	var found_wall = is_on_wall()
	if found_wall and not has_hit_wall:
		direction.x *= -1
		flip_sprite()
		has_hit_wall = true
	elif not found_wall:
		has_hit_wall = false
		
	apply_gravity(delta)
	apply_acceleration(direction.x, MOVE_SPEED, MOVE_SPEED, delta)
	velocity = move_and_slide(velocity, Vector2.UP)
	
func apply_acceleration(direction, speed, acceleration, delta):
	velocity.x = move_toward(velocity.x, speed * direction, acceleration * delta)
	
func flip_sprite():
	scale.x *= -1
	
func apply_gravity(delta):
	velocity.y += gravity * delta
	
func die():
	dead = true
	$Hitbox/CollisionShape2D.set_deferred("disabled", true)
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
	$CollisionShape2D.set_deferred("disabled", true)
	remove_timer.start()
	
func _on_Hurtbox_body_entered(body):
	if body is Player:
		body.bounce(230)
		die()

func _on_Hitbox_body_entered(body):
	if body is Player:
		freeze = true
		sprite.animation = "Attack"
		body.die()


func _on_RemoveTimer_timeout():
	queue_free()
