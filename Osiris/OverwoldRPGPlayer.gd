extends KinematicBody2D

class_name OverworldPlayer

onready var sprite := $AnimatedSprite

export (int) var SPEED = 100
const IDLE_FRONT_ANIM = "IdleForward"
const IDLE_BACK_ANIM = "IdleBack"
const IDLE_SIDE_ANIM = "IdleSide"
const WALK_FRONT_ANIM = "MoveForward" 
const WALK_BACK_ANIM = "MoveBack"
const WALK_SIDE_ANIM = "MoveSide"

var input_vector = Vector2(0, 0)

enum { UP, DOWN, LEFT, RIGHT }
var facing = DOWN

func _physics_process(delta):
	setAnimation()
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
	input_vector = input_vector.normalized()

	move_and_slide(input_vector * SPEED)
	
	Events.player_overworld_position = global_position
	
func setAnimation():
	if input_vector == Vector2.ZERO:
		face_direction()
	else:
		if abs(input_vector.x) > abs(input_vector.y):
			if input_vector.x > 0:
				if sprite.flip_h:
					sprite.flip_h = false 
				sprite.animation = WALK_SIDE_ANIM
				facing = RIGHT
			else:
				sprite.animation = WALK_SIDE_ANIM
				if !sprite.flip_h:
					sprite.flip_h = true
				facing = LEFT
		else:
			if input_vector.y > 0:
				sprite.animation = WALK_FRONT_ANIM
				facing = DOWN
			else:
				sprite.animation = WALK_BACK_ANIM
				facing = UP

func face_direction():
	if facing == UP:
		sprite.animation = IDLE_BACK_ANIM
	elif facing == DOWN:
		sprite.animation = IDLE_FRONT_ANIM
	elif facing == RIGHT:
		sprite.animation = IDLE_SIDE_ANIM
		if sprite.flip_h:
			sprite.flip_h = false
	elif facing == LEFT:
		sprite.animation = IDLE_SIDE_ANIM
		if !sprite.flip_h:
			sprite.flip_h = true
	else:
		sprite.animation = IDLE_FRONT_ANIM
