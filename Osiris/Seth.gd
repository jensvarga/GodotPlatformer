extends KinematicBody2D

const PARTICELS := preload("res://SethDeathParticles.tscn")
const HEAL_SOUND = preload("res://Sound/FX/MISC/heal.wav")
const MAGIC_POP := preload("res://Sound/FX/MISC/magic_effect.wav")
const ATTACK_1 := preload("res://Sound/FX/MISC/Seth_attack_1.wav")
const ATTACK_2 := preload("res://Sound/FX/MISC/Seth_attack_2.wav")
const LAUGH := preload("res://Sound/FX/MISC/seth_laugh.wav")
const DEATH := preload("res://DyingSeth.tscn")
const HAMMER = preload("res://SethHammer.tscn")
const GRAVITY = 540
const THROW_SPEED = 500
const JUMP_SPEED = 400

onready var sprite := $AnimatedSprite
onready var idle_timer := $IdleTimer
onready var spell_timer := $SpellTimer
onready var jump_off_timer := $JumpOffTimer
onready var hammer_throw_pos := $HammerThrowPos
onready var player_raycast := $PlayerRaycast
onready var floor_raycast := $FloorRaycast
onready var animation_player := $AnimationPlayer

enum STATE { IDLE, JUMP, FALL, HAMMER_THROW, JUMP_THROW, HEAL, DEAD, JUMP_OFF, OFF_SCREEN, JUMP_IN }
var state = STATE.IDLE
var velocity := Vector2.ZERO
var direction := 1
var jump_target := Vector2.ZERO
var jump_distance := 0
var jump_direction := Vector2.ZERO
var thrown := false
var last_attack
var hammer_throws := 0
var invincible = false
var platforms = false
var iceicles = false
var off_screen_positions = [
	Vector2(-500, 0),
	Vector2(500, 0),
	Vector2(0, -500),
	Vector2(0, 500),
	Vector2(500, 500),
	Vector2(-500, -500),
	Vector2(-500, 500),
	Vector2(500, -500)
	]

func _ready():
	Events.connect("boss_died", self, "_on_boss_died")
	enter_fall()

func _physics_process(delta):
	match state:
		STATE.IDLE:
			update_idle(delta)
		STATE.HAMMER_THROW:
			update_hammer_throw(delta)
		STATE.JUMP:
			update_jump(delta)
		STATE.FALL:
			update_fall(delta)
		STATE.JUMP_THROW:
			update_jump_throw(delta)
		STATE.HEAL:
			update_heal(delta)
		STATE.JUMP_OFF:
			update_jump_off(delta)
		STATE.OFF_SCREEN:
			update_off_screen(delta)
		STATE.JUMP_IN:
			update_jump_in(delta)

func enter_idle():
	state = STATE.IDLE
	sprite.animation = "Idle"
	idle_timer.wait_time = rand_range(0, 2)
	idle_timer.start()
	velocity.x = 0
	face_player()

func enter_heal():
	invincible = true
	AudioManager.play_sound(HEAL_SOUND)
	state = STATE.HEAL
	sprite.animation = "Heal"
	animation_player.play("Heal")
	Events.emit_signal("heal_boss")
	idle_timer.wait_time = 0.6
	idle_timer.start()
	velocity.x = 0
	face_player()

func enter_platform_spell():
	AudioManager.play_sound(MAGIC_POP)
	invincible = true
	state = STATE.HEAL
	sprite.animation = "Spell"
	animation_player.play("Spell")
	spell_timer.wait_time = 0.6
	spell_timer.start()
	velocity.x = 0
	face_player()
	
func enter_fall():
	state = STATE.FALL
	sprite.animation = "Land"
	velocity.x = 0
	
func enter_throw_hammer():
	state = STATE.HAMMER_THROW
	sprite.animation = "Swing"
	face_player()
	hammer_throws = int(rand_range(3, 8))

func enter_jump():
	AudioManager.play_sound(ATTACK_1)
	state = STATE.JUMP
	sprite.animation = "Jump"
	velocity = Vector2.ZERO
	jump_target = Vector2(clamp(Events.player.global_position.x, -200, 200), 75)
	jump_distance = jump_target.distance_squared_to(global_position)
	jump_direction = (jump_target - global_position).normalized()
	face_player()

func enter_jump_throw():
	AudioManager.play_sound(ATTACK_2)
	state = STATE.JUMP_THROW
	sprite.animation = "JumpAttack"
	velocity = Vector2.ZERO
	jump_target = Vector2(clamp(Events.player.global_position.x, -200, 200), 75)
	jump_distance = jump_target.distance_squared_to(global_position)
	jump_direction = (jump_target - global_position).normalized()
	face_player()

func enter_jump_off():
	state = STATE.JUMP_OFF
	sprite.animation = "Jump"
	if global_position.x > 0:
		jump_target = Vector2(500, 100)
	else:
		jump_target = Vector2(-500, 100)
		
	jump_direction = (jump_target - global_position).normalized()
	jump_off_timer.start()

func enter_off_screen():
	state = STATE.OFF_SCREEN
	var particles := PARTICELS.instance()
	particles.position = global_position
	get_parent().call_deferred("add_child", particles)
	position = off_screen_positions[randi() % off_screen_positions.size()]
	hammer_throws = int(rand_range(10, 20))
	sprite.animation = "Swing"
	velocity = Vector2.ZERO
	AudioManager.play_sound(LAUGH)
	
func update_jump_off(delta):
	var towards = -1 if jump_direction.x < 0 else 1
	velocity = Vector2(towards * JUMP_SPEED, -JUMP_SPEED / 3)
	velocity = move_and_slide(velocity, Vector2.UP)

func update_off_screen(delta):
	if sprite.animation == "Swing" and sprite.frame == 2 and not thrown:
		throw_hammer()
		hammer_throws -= 1
		thrown = true
		position = off_screen_positions[randi() % off_screen_positions.size()]
	if sprite.animation == "Swing" and sprite.frame == 1:
		thrown = false 
	
	if hammer_throws <= 0:
		enter_jump_in()
		return
	
	if not is_on_floor():
		apply_gravity(delta)
	
	velocity = move_and_slide(velocity, Vector2.UP)

func enter_jump_in():
	state = STATE.JUMP_IN
	sprite.animation = "Jump"
	if rand_range(-1, 1) > 0:
		global_position = Vector2(-500, 75)
		jump_target = Vector2(-200, 75)
	else:
		global_position = Vector2(500, 0)
		jump_target = Vector2(200, 75)
	
	face_player()
	
	velocity = Vector2.ZERO
	jump_direction = (jump_target - global_position).normalized()
	
func update_jump_in(delta):
	if global_position.x > -200 and global_position.x < 200:
		enter_fall()
		
	var towards = -1 if jump_direction.x < 0 else 1
	velocity = Vector2(towards * JUMP_SPEED, -JUMP_SPEED / 3)
	velocity = move_and_slide(velocity, Vector2.UP)
	
func update_jump(delta):
	if player_raycast.is_colliding() or \
	   not floor_raycast.is_colliding() or \
	   (global_position.y < 20 and global_position.x > 191) or \
	   (global_position.y < 20 and global_position.x < -191):
		thrown = false
		enter_fall()
		return
		
	var towards = -1 if jump_direction.x < 0 else 1
	velocity = Vector2(towards * JUMP_SPEED, -JUMP_SPEED / 3)
	velocity = move_and_slide(velocity, Vector2.UP)

func update_jump_throw(delta):
	if sprite.frame == 3 and not thrown:
		throw_hammer()
		thrown = true
	if player_raycast.is_colliding() or \
	   not floor_raycast.is_colliding() or \
	   (global_position.y < 20 and global_position.x > 191) or \
	   (global_position.y < 20 and global_position.x < -191):
		thrown = false
		enter_fall()
		return
		
	var towards = -1 if jump_direction.x < 0 else 1
	velocity = Vector2(towards * JUMP_SPEED, -JUMP_SPEED / 3)
	velocity = move_and_slide(velocity, Vector2.UP)

func update_fall(delta):
	if is_on_floor():
		heal_or_idle()
		AudioManager.play_boom()
		CameraShaker.add_trauma(0.4)
		return
	
	velocity.x = max(0, abs(velocity.x) - 20) * direction
	apply_gravity(delta)
	velocity = move_and_slide(velocity, Vector2.UP)
	
func update_idle(delta):
	if not is_on_floor():
		apply_gravity(delta)
	
	velocity = move_and_slide(velocity, Vector2.UP)

func update_heal(delta):
	if not is_on_floor():
		apply_gravity(delta)
	
	velocity = move_and_slide(velocity, Vector2.UP)

func update_hammer_throw(delta):
	if sprite.animation == "Swing" and sprite.frame == 2 and not thrown:
		throw_aimed_hammer()
		hammer_throws -= 1
		thrown = true
	if sprite.animation == "Swing" and sprite.frame == 1:
		thrown = false 
	
	if hammer_throws <= 0:
		heal_or_idle()
		return
	
	if not is_on_floor():
		apply_gravity(delta)
	
	velocity = move_and_slide(velocity, Vector2.UP)

func throw_aimed_hammer():
	if Events.player.is_on_floor():
		throw_hammer()
	else:
		if rand_range(-1, 1) < 0:
			throw_hammer_arch()
		else:
			throw_hammer()

func heal_or_idle():
	if Events.boss_hit_points < 3:
		if rand_range(-4, 1) < 0:
			enter_heal()
		else:
			enter_idle()
	elif Events.boss_hit_points < 12:
		if rand_range(-1, 1) < 0:
			enter_heal()
		else:
			enter_idle()
	else:
		enter_idle()

func throw_hammer():
	face_player()
	AudioManager.play_swoosh()
	var hammer = HAMMER.instance()
	get_parent().call_deferred("add_child", hammer)
	
	hammer.position = hammer_throw_pos.global_position
	var player_position = Events.player.global_position
	var target_offset = player_position - hammer.position
	var throw_direction = target_offset.normalized()
	hammer.linear_velocity = throw_direction * THROW_SPEED
	hammer.gravity_scale = 1.2

func throw_hammer_arch():
	face_player()
	AudioManager.play_swoosh()
	var hammer = HAMMER.instance()
	get_parent().call_deferred("add_child", hammer)

	hammer.position = hammer_throw_pos.global_position
	hammer.apply_central_impulse(Vector2(direction * rand_range(100, 200), -1 * rand_range(100, 200)))

func apply_gravity(delta):
	velocity.y += GRAVITY * delta

func face_player():
	if Events.player == null:
		return
	var new_direction = -1 if Events.player.global_position.x < global_position.x else 1
	if new_direction != direction:
		direction = new_direction
		scale.x *= -1

func random_attack():
	if state == STATE.DEAD:
		return
		
	var nr_of_attacks := 4
	var random = last_attack
	while random == last_attack:
		 random = int(rand_range(1, nr_of_attacks + 1))
	
	match random:
		1:
			enter_jump()
		2:
			enter_throw_hammer()
		3:
			enter_jump_throw()
		4:
			enter_jump_off()
	
	last_attack = random

func on_shot():
	if invincible:
		AudioManager.play_ding()
		return
	if Events.boss_hit_points - 1 > 0:
		if Events.boss_hit_points - 1 == 6 and not platforms:
			platforms = true
			enter_platform_spell()
		elif Events.boss_hit_points - 1 == 4 and not iceicles:
			iceicles = true
			enter_platform_spell()
		else:
			animation_player.play("Hurt")
	else:
		pass
	Events.emit_signal("damage_boss")

func _on_IdleTimer_timeout():
	invincible = false
	random_attack()

func _on_boss_died():
	AudioManager.stop_music()
	var death = DEATH.instance()
	death.position = global_position
	get_parent().call_deferred("add_child", death)
	call_deferred("queue_free")

func _on_Area2D_body_entered(body):
	if body is Player:
		body.hurt()
		body.knockback(Vector2(100 * direction, -200))

func _on_SpellTimer_timeout():
	enter_heal()

func _on_JumpOffTimer_timeout():
	enter_off_screen()
