extends Enemy

export (int) var MOVE_SPEED = 25

var direction = Vector2.LEFT
var velocity = Vector2.ZERO
var gravity = 9

onready var ledgeCheckRight: = $LedgeCheckRight
onready var ledgeCheckLeft: = $LedgeCheckLeft
onready var shell_check_front: = $ShellCheckFront
onready var shell_check_back: = $ShellCheckBack
onready var collision_shape: = $CollisionShape2D
onready var hitbox = $Hitbox
onready var sprite: = $AnimatedSprite

var freeze = false

func _physics_process(delta):
	if freeze: return
	
	apply_gravity()
	
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

func apply_gravity():
	velocity.y += gravity

func face(body):
	var direction = -1
	var shell_center_x = global_transform.origin.x + collision_shape.shape.extents.x / 2
	var player_center_x = body.global_transform.origin.x + body.collision_shape.shape.extents.x / 2
	if player_center_x > shell_center_x:
		direction = 1
	
	if (direction > 0 and not sprite.flip_h) or (direction < 0 and sprite.flip_h):
		flip_sprite()

func _on_Area2D_body_entered(body):
	if body is Scarabu:
		if body.state == body.KICKED:
			die()
