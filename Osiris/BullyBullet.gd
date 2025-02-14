extends Area2D

const SPEED = 150

onready var sprite := $Sprite
onready var collider := $BounceArea/CollisionShape2D

var direction = Vector2.ZERO
var velocity = Vector2.ZERO

func set_direction(_direction: Vector2):
	direction = _direction.normalized()

func _physics_process(delta):
	velocity = SPEED * direction
	translate(velocity * delta)
	
func destroy():
	AudioManager.play_random_hit_sound()
	call_deferred("queue_free")

func _on_VisibilityNotifier2D_screen_exited():
	call_deferred("queue_free")

func _on_BounceArea_body_entered(body):
	if body is Player:
		collider.set_deferred("disabled", true)
		body.bounce(500)
		destroy()

func _on_BullyBullet_body_entered(body):
	if body is Player:
		body.hurt()
