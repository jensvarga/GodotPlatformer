extends KinematicBody2D

export (int) var MOVE_SPEED = 25

var direction = Vector2.LEFT
var velocity = Vector2.ZERO

onready var ledgeCheckRight: = $LedgeCheckRight
onready var ledgeCheckLeft: = $LedgeCheckLeft
onready var hitbox = $Hitbox

func _physics_process(delta):
	var found_wall = is_on_wall()
	var found_ledge_right = not ledgeCheckRight.is_colliding()
	var found_ledge_left = not ledgeCheckLeft.is_colliding()
	var found_ledge = found_ledge_right or found_ledge_left
	
	if found_wall or found_ledge:
		direction *= -1
		flip_sprite()
		
	velocity = direction * MOVE_SPEED

	$AnimatedSprite.animation = "Walk"
	move_and_slide(velocity, Vector2.UP)

func attack():
	$AnimatedSprite.animation = "Attack"
	
func flip_sprite():
	$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
