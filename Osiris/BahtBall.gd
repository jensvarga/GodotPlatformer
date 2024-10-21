extends AnimatedSprite
class_name BahtBall

const SPEED = 100
var _direction: Vector2

func set_direction(direction: Vector2):
	self._direction = direction

func _physics_process(delta):
	if _direction.length() > 0:
		global_position += _direction * SPEED * delta

func _on_Area2D_body_entered(body):
	if body is Player:
		body.hurt()
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
