extends KinematicBody2D

class_name Player

export (Resource) var player_move_data

var velocity = Vector2.ZERO
var crouch = false
enum { MOVE, CLIMB }
var state = MOVE
var climb_speed = 50
var max_extra_height = -10

onready var sprite = $AnimatedSprite
onready var ladder_check = $LadderCheck
onready var collision_shape = $CollisionShape2D

func _ready():
	enter_move()

func _physics_process(delta):
	match state:
		MOVE:
			update_move()
		CLIMB:
			update_climb()

func enter_move():
	sprite.animation = "Idle"
	state = MOVE
	
func enter_climb():
	sprite.animation = "ClimbIdle"
	state = CLIMB

func update_move():
	if is_on_ladder() and (Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down")):
		enter_climb()
		return
		
	apply_gravity()
	if crouch && Input.is_action_just_released("ui_down"):
		crouch = false
	
	var input = Vector2.ZERO
	input.x = Input.get_axis("ui_left", "ui_right")
	input.y = Input.get_axis("ui_up", "ui_down")
	
	if Input.is_action_pressed("ui_down"):
		crouch = true
	
	if input.x == 0 or crouch:
		apply_friction()
		if crouch:
			sprite.animation = "Crouch"
		else:
			sprite.animation = "Idle"
	else:
		flip_sprite(input.x)
		apply_acceleration(input.x)
		sprite.animation = "Run"
		
	var extra = 0
	if is_on_floor():
		if Input.is_action_just_pressed("ui_jump"):
			var horizontal_speed = abs(velocity.x)
			
			if horizontal_speed > 0:
				extra = max(max_extra_height, (horizontal_speed / player_move_data.MOVE_SPEED) * max_extra_height)
				
			var height = player_move_data.MAX_JUMP_HEIGHT + extra
			velocity.y = height
	else:
		if not crouch:
			sprite.animation = "Jump"
			
		if Input.is_action_just_released("ui_jump") and velocity.y < player_move_data.MIN_JUMP_HEIGHT:
			var height = player_move_data.MIN_JUMP_HEIGHT + extra
			velocity.y = height
			
		if velocity.y > 0:
			apply_gravity()
			
			if not crouch:
				sprite.animation = "Fall"
	
	velocity = move_and_slide(velocity, Vector2.UP)

func update_climb():
	if !is_on_ladder():
		enter_move()
		return
	if is_on_floor() and Input.is_action_just_released("ui_down"):
		enter_move()
		return
	
	get_input()
	
	if velocity.y > 0:
		sprite.animation = "ClimbDown"
	elif velocity.y < 0:
		sprite.animation = "ClimbUp"
	else:
		sprite.animation = "ClimbIdle"
	
	velocity = move_and_slide(velocity, Vector2.UP)

func is_on_ladder():
	return ladder_check.is_colliding()
	
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
	
func apply_climb_acceleration(amount):
	velocity.y = move_toward(velocity.y, player_move_data.MOVE_SPEED * amount, player_move_data.ACCELERATION)

func flip_sprite(input_x):
	sprite.flip_h = input_x < 0

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	elif Input.is_action_pressed("ui_down"):
		velocity.y += 1
	elif Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	velocity = velocity.normalized() * climb_speed

# Public functions
func die():
	get_tree().reload_current_scene()
	
func bounce(amount):
	velocity.y += -amount
