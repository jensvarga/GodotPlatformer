extends KinematicBody2D

class_name Player

export (Resource) var player_move_data

var velocity = Vector2.ZERO
var crouch = false

func _physics_process(delta):
	apply_gravity()
	
	if crouch && Input.is_action_just_released("ui_down"):
		crouch = false
	
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if Input.is_action_pressed("ui_down"):
		crouch = true
	
	if input.x == 0 or crouch:
		apply_friction()
		if crouch:
			$AnimatedSprite.animation = "Crouch"
		else:
			$AnimatedSprite.animation = "Idle"
	else:
		flip_sprite(input.x)
		apply_acceleration(input.x)
		$AnimatedSprite.animation = "Run"
		
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = player_move_data.MAX_JUMP_HEIGHT
	else:
		if not crouch:
			$AnimatedSprite.animation = "Jump"
			
		if Input.is_action_just_released("ui_up") and velocity.y < player_move_data.MIN_JUMP_HEIGHT:
			
			velocity.y = player_move_data.MIN_JUMP_HEIGHT
			
		if velocity.y > 0:
			apply_gravity()
			
			if not crouch:
				$AnimatedSprite.animation = "Fall"
	
	velocity = move_and_slide(velocity, Vector2.UP)

func apply_gravity():
	velocity.y += player_move_data.GRAVITY
	if crouch:
		velocity.y = min(velocity.y, 400)
	else:
		velocity.y = min(velocity.y, 200)
	
func apply_friction():
	velocity.x = move_toward(velocity.x, 0, player_move_data.FRICTION)

func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, player_move_data.MOVE_SPEED * amount, player_move_data.ACCELERATION)

func flip_sprite(input_x):
	$AnimatedSprite.flip_h = input_x < 0
	

func die():
	get_tree().reload_current_scene()
