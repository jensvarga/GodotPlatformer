extends KinematicBody2D

class_name Paro

const MISSILE := preload("res://ParoMissile.tscn")
const BOULDER := preload("res://ParoBoulder.tscn")
const DEATH_PARTS = preload("res://ParoParticles.tscn")
const GRAVITY = 540
const ROCK_SPEED = 400

onready var sprite := $AnimatedSprite
onready var full_body_collision_shape := $CollisionShape2D
onready var rock_collision_shape := $RockCollisionShape
onready var animation_player := $AnimationPlayer
onready var hurt_collider_body := $HurtArea/BodyCollider
onready var hurt_collider_rock := $HurtArea/RockColllider
onready var bounce_collider := $BounceArea/CollisionShape2D
onready var ray_cast := $RayCast2D

onready var attack_timer := $AttackTimer
onready var spin_timer := $SpinTimer
onready var enter_delay := $EnterDelay
onready var iframes_timer := $IFramesTimer

enum State {Enter, Idle, Fire, SpinAttack, ThrowBoulder, Dead}
var state = State.Enter
var velocity = Vector2.ZERO
var direction = Vector2.LEFT
var invincible = true
var stop_spinning = false
var nr_of_missiles = 4
var last_attack = 0

func _ready():
	Events.connect("player_died", self, "_on_player_died")
	Events.connect("boss_died", self, "_on_boss_died")
	sprite.playing = false
	hide()
	full_body_collision_shape.set_deferred("disabled", true)
	enter_delay.start()
	
func _physics_process(delta):
	match state:
		State.Enter:
			update_enter()
		State.Idle:
			update_idle(delta)
		State.Fire:
			update_fire(delta)
		State.ThrowBoulder:
			pass
		State.SpinAttack:
			update_spin_attack(delta)
		State.Dead:
			pass
			
	velocity = move_and_slide(velocity, Vector2.UP)

### Enter States

func enter_enter():
	show()
	AudioManager.play_roar()
	sprite.animation = "Enter"
	sprite.frame = 0
	sprite.playing = true
	state = State.Enter
	
func enter_idle():
	if state == State.Dead:
		return
	state = State.Idle
	invincible = false
	sprite.animation = "Idle"
	face_direction()
	global_position.y = 30
	velocity.x = 0
	full_body_collision_shape.set_deferred("disabled", false)
	hurt_collider_body.set_deferred("disabled", false)
	rock_collision_shape.set_deferred("disabled", true)
	hurt_collider_rock.set_deferred("disabled", true)
	attack_timer.wait_time = 2
	attack_timer.start()

func enter_fire():
	state = State.Fire
	sprite.animation = "Fire"
	
	fire_missiles_up()
	yield(get_tree().create_timer(2), "timeout")
	sprite.animation = "Fired"
	fire_missiles_down()
	yield(get_tree().create_timer(1), "timeout")
	if not state == State.Dead:
		enter_idle()

func enter_boulder_throw():
	state = State.ThrowBoulder
	sprite.animation = "Fire"
	
	throw_boulders()
	yield(get_tree().create_timer(3), "timeout")
	sprite.animation = "Fired"
	yield(get_tree().create_timer(1), "timeout")
	if not state == State.Dead:
		enter_idle()
	
func enter_spin_attack():
	state = State.SpinAttack
	sprite.animation = "SpinAttack"
	full_body_collision_shape.set_deferred("disabled", true)
	hurt_collider_body.set_deferred("disabled", true)
	rock_collision_shape.set_deferred("disabled", false)
	hurt_collider_rock.set_deferred("disabled", false)
	invincible = true
	spin_timer.wait_time = rand_range(2, 5)
	spin_timer.start()

func enter_dead():
	var particles := DEATH_PARTS.instance()
	particles.position = global_position
	get_parent().call_deferred("add_child", particles)
	
	state = State.Dead
	
	attack_timer.stop()
	spin_timer.stop()
	iframes_timer.stop()
	enter_delay.stop()
	
	sprite.hide()
	
	full_body_collision_shape.set_deferred("disabled", true)
	rock_collision_shape.set_deferred("disabled", true)
	bounce_collider.set_deferred("disabled", true)
	hurt_collider_body.set_deferred("disabled", true)
	hurt_collider_rock.set_deferred("disabled", true)
	
	AudioManager.stop_music()
	AudioManager.play_aphopis_hurt_sound()
	AudioManager.play_boom()

### Update States

func update_enter():
	if sprite.frame == 9:
		CameraShaker.add_trauma(0.4)
		enter_idle()

func update_idle(delta):
	apply_gravity(delta)

func update_fire(delta):
	apply_gravity(delta)

func update_spin_attack(delta):
	apply_gravity(delta)
	velocity.x = direction.x * ROCK_SPEED

	if ray_cast.is_colliding():
		direction.x *= -1
		ray_cast.scale.x *= -1
		CameraShaker.add_trauma(0.5)
	
	if stop_spinning && (global_position.x <= -200 or global_position.x >= 200):
		stop_spinning = false
		if not state == State.Dead:
			enter_idle()
	
### Misc

func throw_boulders():
	var nr_of_boulder = int(rand_range(3, 8))
	
	for i in range(nr_of_boulder):
		if state == State.Dead:
			return
		var boulder = BOULDER.instance()
		boulder.set_deferred("direction", direction.x)
		boulder.position = Vector2(global_position.x + 50 * direction.x, global_position.y)
		get_parent().call_deferred("add_child", boulder)
		AudioManager.play_random_explosion_sound()
		CameraShaker.add_trauma(.3)
		
		yield(get_tree().create_timer(1), "timeout")

func fire_missiles_up():
	nr_of_missiles = int(rand_range(4, 8))
	
	for i in range(nr_of_missiles):
		if state == State.Dead:
			return
		var missile = MISSILE.instance()
		missile.position = global_position 
		get_parent().call_deferred("add_child", missile)
		missile.set_direction(Vector2(0, -1), -90)
		AudioManager.play_random_explosion_sound()
		CameraShaker.add_trauma(.3)
		
		yield(get_tree().create_timer(0.5), "timeout")

func fire_missiles_down():
	for i in range(nr_of_missiles):
		if state == State.Dead:
			return
		var target_pos = Vector2(Events.player.global_position.x, -140)
		var missile = MISSILE.instance()
		
		missile.position = target_pos 
		get_parent().call_deferred("add_child", missile)
		missile.set_direction(Vector2(0, 1), 90)
		AudioManager.play_random_explosion_sound()
		CameraShaker.add_trauma(.25)
		
		yield(get_tree().create_timer(0.5), "timeout")

func face_direction():
	if global_position.x > 0:
		sprite.flip_h = false
		direction.x = -1
	else:
		sprite.flip_h = true
		direction.x = 1

func apply_gravity(delta):
	velocity.y += GRAVITY * delta
	
func fire_missile():
	pass

func on_shot():
	if not invincible:
		if Events.boss_hit_points - 1 <= 0:
			Events.emit_signal("damage_boss")
		else:
			Events.emit_signal("damage_boss")
			animation_player.play("Hurt")
			AudioManager.play_roar()
			invincible = true
			iframes_timer.start()
			
			if state == State.Idle:
				attack_timer.stop()
				random_attack()
	else:
		animation_player.play("AltHurt")

func random_attack():
	if state == State.Dead:
		return
		
	var nr_of_attacks := 3
	var random = last_attack
	while random == last_attack:
		 random = int(rand_range(1, nr_of_attacks + 1))
	
	match random:
		1:
			enter_spin_attack()
		2:
			enter_fire()
		3:
			enter_boulder_throw()
	
	last_attack = random

func _on_EnterDelay_timeout():
	enter_enter()
	AudioManager.play_random_explosion_sound()
	AudioManager.play_low_rumble()
	yield(get_tree().create_timer(1), "timeout")
	AudioManager.play_paro_music()

func _on_AttackTimer_timeout():
	random_attack()

func _on_HurtArea_body_entered(body):
	if body is Player:
		body.hurt()
		body.bounce(400)
		body.recoil(direction.x * 200)

func _on_SpinTimer_timeout():
	stop_spinning = true

func _on_BounceArea_body_entered(body):
	if body is Player:
		body.bounce(400)
		body.recoil(direction.x * 200)

func _on_player_died():
	sprite.animation = "Win"
	global_position.y = 30

func _on_IFramesTimer_timeout():
	if state == State.SpinAttack:
		invincible = false

func _on_boss_died():
	enter_dead()
