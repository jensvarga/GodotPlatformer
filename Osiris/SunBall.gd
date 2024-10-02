extends Area2D

const SPEED = 300

var direction = Vector2.ZERO
var velocity = Vector2.ZERO
onready var sprite := $AnimatedSprite

func set_direction(_direction: Vector2):
	direction = _direction.normalized()
	rotation = direction.angle()

func _physics_process(delta):
	sprite.rotation += delta * 5 
	velocity = SPEED * direction
	translate(velocity * delta)
	
func destroy():
	AudioManager.play_random_hit_sound()
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_SunBall_body_entered(body):
	if body is Player:
		body.hurt()
		var dir = (body.global_position - global_position).normalized()
		body.knockback(dir * 200)
		destroy()
