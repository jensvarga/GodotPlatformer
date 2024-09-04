extends KinematicBody2D

export (Vector2) var DIRECTION = Vector2.RIGHT
export (int) var MOVE_SPEED = 200

onready var sprite: = $AnimatedSprite
onready var collider: = $Area2D/CollisionShape2D

var velocity = Vector2.ZERO
var stopped = true
var first = true

func _ready():
	sprite.rotation = DIRECTION.angle()
	disable_colliders()
	
func _physics_process(delta):
	if stopped: return
	velocity = DIRECTION * MOVE_SPEED
	velocity = move_and_slide(velocity, Vector2.UP)
	
func activate(direction):
	sprite.visible = true
	DIRECTION = direction
	sprite.rotation = DIRECTION.angle()
	enable_colliders()
	stopped = false
	if first:
		first = false
		return
	AudioManager.play_random_explosion_sound()
	
func deactivate():
	disable_colliders()
	sprite.visible = false

func disable_colliders():
	collider.set_deferred("disabled", true)
	
func enable_colliders():
	collider.set_deferred("disabled", false)

func _on_Area2D_body_entered(body):
	if body is Player:
		body.hurt()
	else:
		stopped = true
		deactivate()
