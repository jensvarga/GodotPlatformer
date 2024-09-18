extends KinematicBody2D

class_name Player

export (Resource) var player_move_data
var hurt_particles = preload("res://PlayerHurtParticles.tscn")
const FIREBALL = preload("res://PowerCrookFireball.tscn")
const IMPACT_DUST_A = preload("res://impact_dust_a.tscn")
const MAGIC_EFFECT = preload("res://MagicEffect.tscn")
const IMPACT_DUST = preload("res://impact_dust_b.tscn")

var velocity = Vector2.ZERO
var crouch = false
enum { MOVE, CLIMB, DEAD }
var state = MOVE
var climb_speed = 75
var max_extra_height = -10
var buffered_jump = false
var coyote_jump = false
var gorund_speed_bonus = 5

# Wall jumping
var holding_wall = false
var jump_from_right = false
var jump_from_left = false

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
onready var wall_check_left := $WallDetectorLeft
onready var wall_check_right := $WallDetectorRight
onready var climb_timber := $ClimbTimer
onready var animation_player := $AnimationPlayer
onready var invincible_timer := $InvincibleTimer
onready var right_fire_position := $RightFirePosition
onready var left_fire_position := $LeftFirePosition
onready var fire_delay_timer := $FireDelayTimer
onready var lower_left_fire_position := $LowerLeftFirePosition
onready var lower_right_fire_position := $LowerRightFirePosition


var look_up = false
var invincible = false

# Item handeling
var item_instsance
var carry_item = null
var item_holder = null
var carrying = false
var start_grab_position = 1
var fire_delay = false
var firing = false

func _ready():
	Events.connect("pick_up_power_up", self, "_on_pick_up_power_up" )
	start_grab_position = grab_position.position.x
	enter_move()
	crouch_collider.set_deferred("disabled", true)
	animation_player.play("RESET")

func _physics_process(delta):
	if state != DEAD and Events.player_hit_points <= 0:
		enter_dead()
	# item check
	if state != DEAD:
		if not carrying and carry_item != null and Input.is_action_just_pressed("ui_grab"):
			grab_item()
			
	if not holding_wall and not carrying and Input.is_action_just_pressed("ui_fire") and state != CLIMB:
		fire_fireball()
		
	match state:
		MOVE:
			update_move(delta)
		CLIMB:
			update_climb(delta)
		DEAD:
			update_dead()
	
	if state != DEAD and firing:
		sprite.animation = "Fire"
		if sprite.flip_h:
			sprite.offset.x = -10
		else:
			sprite.offset.x = 10
	else:
		sprite.offset.x = 0
			
func _input(event):
	if event.is_action_pressed("ui_up"):
		look_up = true
	if event.is_action_released("ui_up"):
		look_up = false
	if carrying and event.is_action_released("ui_grab"):
		drop_item()

func fire_fireball():
	if state == DEAD:
		return
	if not Events.has_power_crook:
		return
	if fire_delay:
		return
		
	sprite.animation = "Fire"
	fire_delay = true
	fire_delay_timer.start()
	
	var fireball = FIREBALL.instance()
	get_tree().root.get_child(4).call_deferred("add_child", fireball)
	
	var magic_effect := MAGIC_EFFECT.instance()
	#add_child(magic_effect)
	get_tree().root.get_child(4).call_deferred("add_child", magic_effect)
	
	var direction = -1 if sprite.flip_h else 1
	fireball.set_direction(direction)

	var fire_position: Node2D

	if sprite.flip_h:
		fire_position = lower_left_fire_position if crouch else left_fire_position
	else:
		fire_position = lower_right_fire_position if crouch else right_fire_position

	fireball.position = fire_position.global_position
	magic_effect.position = fire_position.global_position
	
	var random_effect = ["Effect1", "Effect2", "Effect3"][int(rand_range(0, 3))]
	
	magic_effect.call_deferred("set_animation", random_effect, direction)
	#magic_effect.set_animation(random_effect, direction)
	
	firing = true
	$FireAnimationTimer.start()
	
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
		set_idle_animation()
	state = MOVE
	
func enter_climb():
	sprite.animation = "ClimbIdle"
	state = CLIMB
	
func update_dead():
	pass

func holding_left_wall():
	return wall_check_left.is_colliding() and Input.is_action_pressed("ui_left")
	
func holding_right_wall():
	return wall_check_right.is_colliding() and Input.is_action_pressed("ui_right")
	
func update_wall_jumping(grounded: bool):
	if grounded or carrying or crouch:
		holding_wall = false
		jump_from_left = false
		jump_from_right = false
		return
		
	if not jump_from_left and not jump_from_right:
		holding_wall = holding_left_wall() or holding_right_wall()
		return
	
	if jump_from_left:
		holding_wall = holding_right_wall()
		return
		
	if jump_from_right:
		holding_wall = holding_left_wall()
		return

func update_move(delta):
	var grounded = is_on_floor()
	update_wall_jumping(grounded)
	set_carry_item_height()
	
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
			if carrying:
				sprite.animation = "CrouchCarry"
			else:
				sprite.animation = "Crouch"
			crouch_collider.set_deferred("disabled", false)
			collision_shape.set_deferred("disabled", true)
		else:
			if carrying:
				sprite.animation = "IdleCarry"
			elif not holding_wall:
				set_idle_animation()
			crouch_collider.set_deferred("disabled", true)
			collision_shape.set_deferred("disabled", false)
	else:
		flip_sprite(input.x)
		apply_acceleration(input.x, grounded, delta)
		if carrying:
			sprite.animation = "RunCarry"
		else:
			if holding_wall:
				sprite.animation = "WallHold"
			else:
				set_run_animation()
		crouch_collider.set_deferred("disabled", true)
		collision_shape.set_deferred("disabled", false)
		
	var extra = 0
	var jump = false
	
	if grounded or coyote_jump or holding_wall:
		jump = Input.is_action_just_pressed("ui_jump") or buffered_jump
		if jump:
			if holding_left_wall() or holding_right_wall():
				var impact_dust = IMPACT_DUST_A.instance()
				get_parent().call_deferred("add_child", impact_dust)
				impact_dust.position = global_position
				if holding_left_wall():
					holding_wall = false
					jump_from_left = true
					jump_from_right = false
				elif holding_right_wall():
					impact_dust.scale.x *= -1
					holding_wall = false
					jump_from_left = false
					jump_from_right = true
					
				
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
				set_jump_animation()

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
					set_fall_animation()
	
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
	if holding_wall:
		velocity.y = 0
		velocity.y += (player_move_data.GRAVITY / 2) * delta
	else:
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

func hurt():
	if invincible:
		return
	invincible = true
	animation_player.play("Hurt")
	Events.emit_signal("player_take_damage")
	invincible_timer.start()
	AudioManager.play_random_hit_sound()
	var particles = hurt_particles.instance()
	particles.position = position
	get_parent().call_deferred("add_child", particles)
	
func bounce(amount):
	yield(get_tree(), "physics_frame")
	var impact_dust = IMPACT_DUST.instance()
	get_parent().call_deferred("add_child", impact_dust)
	impact_dust.position = Vector2(global_position.x, global_position.y + 5)
	AudioManager.play_random_hit_sound()
	velocity.y += -amount
	
func connect_camera(camera):
	#var camera_path = camera.get_path()
	#remote_transform.remote_path = camera_path
	pass

func set_run_animation():
	if Events.has_power_crook:
		sprite.animation = "RunCrook"
	else:
		sprite.animation = "Run"

func set_idle_animation():
	if Events.has_power_crook:
		sprite.animation = "IdleCrook"
	else:
		sprite.animation = "Idle"
		
func set_jump_animation():
	if Events.has_power_crook:
		sprite.animation = "JumpCrook"
	else:
		sprite.animation = "Jump"
		
func set_fall_animation():
	if Events.has_power_crook:
		sprite.animation = "FallCrook"
	else:
		sprite.animation = "Fall"
		
func grab_item():
	if item_holder.has_method("picked_up"):
		item_holder.picked_up()
	sprite.animation = "IdleCarry"
	if carry_item == null: return
	item_instsance = carry_item.instance()
	grab_position.call_deferred("add_child", item_instsance)
	carrying = true
	
func drop_item():
	set_idle_animation()
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
	
func set_carry_item_height():
	if not carrying:
		return
		
	if item_instsance != null:
		item_instsance.position.y = grab_position.position.y + 6
		if crouch:
			item_instsance.position.y = grab_position.position.y + 13
	
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

func _on_InvincibleTimer_timeout():
	invincible = false

func _on_RoomDetector_area_entered(area):
	var collision_shape: CollisionShape2D = area.get_node("CollisionShape2D")
	var size: Vector2 = collision_shape.shape.extents * 2
	
	Events.change_room(collision_shape.global_position, size)

func _on_FireDelayTimer_timeout():
	fire_delay = false

func _on_pick_up_power_up():
	animation_player.play("PowerUp")

func _on_FireAnimationTimer_timeout():
	firing = false
