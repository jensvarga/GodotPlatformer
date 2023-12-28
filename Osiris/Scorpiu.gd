extends Enemy

export (int) var MOVE_SPEED = 25

var direction = Vector2.LEFT
var velocity = Vector2.ZERO
var gravity = 9

onready var ledgeCheckRight: = $LedgeCheckRight
onready var ledgeCheckLeft: = $LedgeCheckLeft
onready var hitbox = $Hitbox

func _physics_process(delta):
	apply_gravity()
	
	var found_wall = is_on_wall()
	var found_ledge_right = not ledgeCheckRight.is_colliding()
	var found_ledge_left = not ledgeCheckLeft.is_colliding()
	var found_ledge = found_ledge_right or found_ledge_left
	
	if found_wall or found_ledge:
		direction *= -1
		flip_sprite()
		
	velocity = direction * MOVE_SPEED

	$AnimatedSprite.animation = "Walk"
	velocity = move_and_slide(velocity, Vector2.UP)

func attack():
	$AnimatedSprite.animation = "Attack"
	
func flip_sprite():
	$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h

func apply_gravity():
	velocity.y += gravity
