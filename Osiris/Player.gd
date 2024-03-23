extends KinematicBody2D

class_name Player

export (Resource) var player_move_data

var velocity = Vector2.ZERO
var crouch = false
enum { MOVE, CLIMB, DEAD }
var state = MOVE
var climb_speed = 50
var max_extra_height = -10
var buffered_jump = false
var coyote_jump = false
var gorund_speed_bonus = 5

onready var sprite: = $AnimatedSprite
onready var ladder_check: = $LadderCheck
onready var collision_shape: = $CollisionShape2D
onready var crouch_collider: = $CrouchCollider
onready var jump_buffer_timer: = $JumpBufferTimer
onready var coyote_timer: = $CoyoteTimer
onready var death_timer: = $DeathTimer
onready var remote_transform: = $RemoteTransform2D
onready var grab_position: = $GrabPosition
onready var item_check_right: = $ItemCheck/Right
onready var item_check_left: = $ItemCheck/Left

var look_up = false

# Item handeling
var item_instsance
var carry_item = null
var item_holder = null
var carrying = false
var start_grab_position = 1

func _ready():
	start_grab_position = grab_position.position.x
	enter_move()
	crouch_collider.set_deferred("disabled", true)

func _physics_process(delta):
	# item check
	if state != DEAD:
		if not carrying and carry_item != null and Input.is_action_just_pressed("ui_grab"):
			grab_item()
		
	match state:
		MOVE:
			update_move(delta)
		CLIMB:
			update_climb(delta)
		DEAD:
			update_dead()
			
func _input(event):
	if event.is_action_pressed("ui_up"):
		look_up = true
	if event.is_action_released("ui_up"):
		look_up = false
	if carrying and event.is_action_released("ui_grab"):
		drop_item()
		
func enter_dead():
	if carrying: drop_item()
	AudioManager.play_random_die_sound()
	state = DEAD
	death_timer.start()
	sprite.animation = "Dead"
	
func enter_move():
	if carrying:
		sprite.animation = "IdleCarry"
	else:
		sprite.animation = "Idle"
	state = MOVE
	
func enter_climb():
	sprite.animation = "ClimbIdle"
	state = CLIMB

func update_dead():
	pass
	
func update_move(delta):
	var grounded = is_on_floor()
	
	if not carrying and is_on_ladder() and (Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down")):
		enter_climb()
		return
	
	if velocity == Vector2.ZERO && look_up:
		sprite.animation = "LookUp"
		crouch_collider.set_deferred("disabled", true)
		collision_shape.set_deferred("disabled", false)
		return
		
	apply_gravity(delta)
	clamp_jump_force()
	
	if crouch && Input.is_action_just_released("ui_down"):
		crouch = false
	
	var input = Vector2.ZERO
	input.x = Input.get_axis("ui_left", "ui_right")
	input.y = Input.get_axis("ui_up", "ui_down")
	
	if Input.is_action_pressed("ui_down"):
		crouch = true
	
	if input.x == 0 or crouch:
		apply_friction(delta)
		if crouch:
			sprite.animation = "Crouch"
			crouch_collider.set_deferred("disabled", false)
			collision_shape.set_deferred("disabled", true)
		else:
			if carrying:
				sprite.animation = "IdleCarry"
			else:
				sprite.animation = "Idle"
			crouch_collider.set_deferred("disabled", true)
			collision_shape.set_deferred("disabled", false)
	else:
		flip_sprite(input.x)
		apply_acceleration(input.x, grounded, delta)
		if carrying:
			sprite.animation = "RunCarry"
		else:
			sprite.animation = "Run"
		crouch_collider.set_deferred("disabled", true)
		collision_shape.set_deferred("disabled", false)
		
	var extra = 0
	var jump = false
	if grounded or coyote_jump:
		jump = Input.is_action_just_pressed("ui_jump") or buffered_jump
		if jump:
			AudioManager.play_random_jump_sound()
			var horizontal_speed = abs(velocity.x)
			
			if horizontal_speed > 0:
				extra = max(max_extra_height, (horizontal_speed / player_move_data.MOVE_SPEED) * max_extra_height)
				
			var height = player_move_data.MAX_JUMP_HEIGHT + extra
			velocity.y = height

			buffered_jump = false
	else:
		if not crouch:
			if carrying:
				sprite.animation = "JumpCarry"
			else:
				sprite.animation = "Jump"

		if Input.is_action_just_released("ui_jump") and velocity.y < player_move_data.MIN_JUMP_HEIGHT:
			var height = player_move_data.MIN_JUMP_HEIGHT + extra
			velocity.y = height
		
		if Input.is_action_just_pressed("ui_jump"):
			buffered_jump = true
			jump_buffer_timer.start()
		
		if velocity.y > 0:
			apply_gravity(delta)
			
			if not crouch:
				if carrying:
					sprite.animation = "FallCarry"
				else:
					sprite.animation = "Fall"
	
	var was_on_floor = grounded
	#var snap = Vector2.DOWN * 32 if !jump else Vector2.ZERO
	#velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP)
	velocity = move_and_slide(velocity, Vector2.UP)
	
	var just_left_ground = not is_on_floor() and was_on_floor
	if just_left_ground and velocity.y >= 0:
		coyote_jump = true
		coyote_timer.start()

func update_climb(delta):
	if !is_on_ladder():
		enter_move()
		return
	if is_on_floor() and Input.is_action_just_released("ui_down"):
		enter_move()
		return
	
	get_input()
	
	if velocity.y > 0 or velocity.x > 0:
		sprite.animation = "ClimbDown"
	elif velocity.y < 0 or velocity.x < 0:
		sprite.animation = "ClimbUp"
	else:
		sprite.animation = "ClimbIdle"
	
	velocity = move_and_slide(velocity, Vector2.UP)

func is_on_ladder():
	return ladder_check.is_colliding()
	
func apply_gravity(delta):
	velocity.y += player_move_data.GRAVITY * delta
	if crouch:
		velocity.y = min(velocity.y, 400)
	else:
		velocity.y = min(velocity.y, 200)
	
func apply_friction(delta):
	velocity.x = move_toward(velocity.x, 0, player_move_data.FRICTION * delta)

func apply_acceleration(amount, is_grounded, delta):
	if is_grounded:
		velocity.x = move_toward(velocity.x, (player_move_data.MOVE_SPEED + gorund_speed_bonus) * amount, player_move_data.ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, player_move_data.MOVE_SPEED * amount, player_move_data.ACCELERATION * delta)
	
func apply_climb_acceleration(amount, delta):
	velocity.y = move_toward(velocity.y, player_move_data.MOVE_SPEED * amount, player_move_data.ACCELERATION * delta)

func flip_sprite(input_x):
	var prevoius_flip = sprite.flip_h 
	sprite.flip_h = input_x < 0
	grab_position.position.x = start_grab_position * input_x
	if item_instsance != null:
		item_instsance.flip_h = sprite.flip_h
	
	# Flipped this frame
	if not prevoius_flip and sprite.flip_h:
		item_check_left.set_deferred("disabled", false)
		item_check_right.set_deferred("disabled", true)
	elif prevoius_flip and not sprite.flip_h:
		item_check_left.set_deferred("disabled", true)
		item_check_right.set_deferred("disabled", false)
	
	
func get_input():
	var input = Vector2.ZERO
	input.x = Input.get_axis("ui_left", "ui_right")
	input.y = Input.get_axis("ui_up", "ui_down")
	
	velocity = input.normalized() * climb_speed

func clamp_jump_force():
	velocity.y = max(velocity.y, player_move_data.MAX_JUMP_HEIGHT - 100)
	
func die():
	if state != DEAD: enter_dead()
	
func bounce(amount):
	AudioManager.play_random_hit_sound()
	velocity.y += -amount
	
func connect_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path
		
func grab_item():
	if item_holder.has_method("picked_up"):
		item_holder.picked_up()
	sprite.animation = "IdleCarry"
	if carry_item == null: return
	item_instsance = carry_item.instance()
	grab_position.add_child(item_instsance)
	carrying = true
	
func drop_item():
	sprite.animation = "Idle"
	if item_instsance != null:
		item_instsance.queue_free()
		item_instsance = null
	
	var throw_dir = Vector2.RIGHT
	if sprite.flip_h:
		throw_dir = Vector2.LEFT
		
	if item_holder == null: return
	if item_holder.has_method("drop_item"):
		item_holder.drop_item(position, throw_dir, velocity)
	carrying = false
	
func _on_JumpBufferTimer_timeout():
	buffered_jump = false

func _on_CoyoteTimer_timeout():
	coyote_jump = false

func _on_DeathTimer_timeout():
	Events.emit_signal("player_died")
	queue_free()
	get_tree().reload_current_scene()

func _on_ItemCheck_body_entered(body):
	if not body.has_method("pickup_enabled"): return
	if body.carry_item == null: return
	if body.pickup_enabled():
		carry_item = body.carry_item
		item_holder = body

func _on_ItemCheck_body_exited(body):
	if body == item_holder:
		carry_item = null
		if not carrying:
			item_holder = null
