extends Area2D

onready var animation_player := $AnimationPlayer

const SPEED: int = -100

var started = false
var velocity = Vector2.ZERO

func _ready():
	animation_player.play("Flash")
	
func _physics_process(delta):
	if started:
		velocity.y = SPEED * delta
		translate(velocity)

func _on_GlowingRock_body_entered(body):
	if body is Player:
		var dir = (body.global_position - global_position).normalized()
		body.knockback(dir * 200)
		body.hurt()

func _on_TelegraphTimer_timeout():
	animation_player.play("RESET")
	started = true

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
