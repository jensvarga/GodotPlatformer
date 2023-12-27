extends KinematicBody2D

class_name Scarabu

export (int) var MOVE_SPEED = 15
export (int) var MOVE_ACCELERATION = 5
export (int) var KICKED_SPEED = 150
export (int) var KICKED_ACCELERATION = 20

var direction = Vector2.LEFT
var velocity = Vector2.ZERO
var gravity = 9

onready var ledgeCheckRight: = $LedgeCheckRight
onready var ledgeCheckLeft: = $LedgeCheckLeft
onready var hitbox = $Hitbox
onready var hitbox_collider = $Hitbox/CollisionShape2D
onready var sprite = $AnimatedSprite

enum { MOVE, SHELL, KICKED }
var state = MOVE

var frame_counter = 0

func _ready():
	enter_move()
	
func _physics_process(delta):
	match state:
		MOVE:
			update_move(delta)
		SHELL:
			update_shell()
		KICKED:
			update_kicked(delta)
	
func enter_move():
	state = MOVE
	hitbox_collider.disabled = true
	sprite.animation = "Walk"
	
func enter_shell():
	velocity.x = 0
	state = SHELL
	hitbox_collider.disabled = true
	sprite.animation = "Shell"
	
func enter_kicked(dir):
	state = KICKED
	velocity.x = dir * KICKED_SPEED
	sprite.animation = "Shell"
	
func update_kicked(delta):
	if is_on_wall():
		direction *= -1
	
	apply_gravity()
	apply_acceleration(direction.x, KICKED_SPEED, KICKED_ACCELERATION)
	velocity = move_and_slide(velocity, Vector2.UP)
	
func update_move(delta):
	var found_wall = is_on_wall()
	var found_ledge_right = not ledgeCheckRight.is_colliding()
	var found_ledge_left = not ledgeCheckLeft.is_colliding()
	var found_ledge = found_ledge_right or found_ledge_left
		
	if found_wall or found_ledge:
		direction *= -1
		flip_sprite()

	apply_gravity()
	apply_acceleration(direction.x, MOVE_SPEED, MOVE_ACCELERATION)
	velocity = move_and_slide(velocity, Vector2.UP)
	
func apply_acceleration(amount, speed, acceleration):
	velocity.x = move_toward(velocity.x, speed * amount, acceleration)
	
func update_shell():
	pass
	
func flip_sprite():
	sprite.flip_h = not sprite.flip_h
	
func apply_gravity():
	velocity.y += gravity
	velocity.y = min(velocity.y, 200)
