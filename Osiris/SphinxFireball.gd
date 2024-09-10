extends Area2D

const SPEED = 200

var direction = Vector2.ZERO
var velocity = Vector2.ZERO

func set_direction(_direction: Vector2):
	direction = _direction.normalized()
	rotation = direction.angle()

func _physics_process(delta):
	velocity = SPEED * direction
	translate(velocity * delta)
	
func destroy():
	AudioManager.play_random_hit_sound()
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_SphinxFireball_body_entered(body):
	if body is Player:
		body.hurt()
		destroy()
	if body.has_method("on_shot"):
		body.on_shot() 
		destroy()
	if body.has_method("on_fireballed"):
		body.on_fireballed() 
		destroy()
	else:
		destroy()
