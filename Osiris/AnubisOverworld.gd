extends KinematicBody2D

onready var sprite := $AnimatedSprite
onready var animation_buffer := $AnimationBuffer

var follow_distance = 50
var speed = 99
var velocity = Vector2.ZERO

var moving = false

func _physics_process(delta):
	var direction_to_player = global_position.direction_to(Events.player_overworld_position)
	var face_left = direction_to_player.x > 0
	sprite.flip_h = face_left
	if global_position.distance_squared_to(Events.player_overworld_position) > (follow_distance * follow_distance):
		moving = true
		animation_buffer.start()
		velocity = direction_to_player * speed
		velocity = move_and_slide(velocity)
	setAnimation()
		
func setAnimation():
	if not moving:
		switch_to_animation("Idle")
	else:
		if abs(velocity.x) > abs(velocity.y):
			switch_to_animation("WalkSide")
		else:
			if velocity.y > 0:
				switch_to_animation("WalkDown")
			else:
				switch_to_animation("WalkUp")

func switch_to_animation(animation):
	if sprite.animation == animation: return
	sprite.animation = animation

func _on_AnimationBuffer_timeout():
	moving = false
