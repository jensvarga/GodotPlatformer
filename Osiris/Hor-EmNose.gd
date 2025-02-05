extends Sprite

var velocity = Vector2(100, -200)
const GRAVITY = 540

func _process(delta):
	velocity.y += GRAVITY * delta
	position += velocity * delta

func _on_VisibilityNotifier2D_screen_exited():
	call_deferred("queue_free")
