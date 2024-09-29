extends KinematicBody2D

const SUNBALL = preload("res://SunBall.tscn")
const SPEED = 75
var _speed: int = 0

enum { ENTER, IDLE, FIRE_SPIN, FIRE, CHASE }
var state = IDLE

onready var sprite := $AnimatedSprite
onready var tween := $Tween
onready var idle_timer := $IdleTimer
onready var animation_player := $AnimationPlayer
onready var hurt_animation_player := $HurtAnimationPlayer
onready var fire_spinner_particles1 := $FireSpinnerArea/CPUParticles2D
onready var fire_spinner_particles2 := $FireSpinnerArea/CPUParticles2D2
onready var fire_spinner_collider := $FireSpinnerArea/CollisionShape2D
onready var fire_spin_timer := $FireSpinTimer
onready var fire_spin_area := $FireSpinnerArea
onready var fire_spinner_sun := $FireSpinnerArea/AnimatedSprite
onready var sun1 := $SunPath2D/PathFollow2D/AnimatedSprite
onready var sun1_collider := $SunPath2D/PathFollow2D/Area2D/CollisionShape2D
onready var sun2 := $SunPath2D2/PathFollow2D/AnimatedSprite
onready var sun2_collider := $SunPath2D2/PathFollow2D/Area2D/CollisionShape2D
onready var sun3 := $SunPath2D3/PathFollow2D/AnimatedSprite
onready var sun3_collider := $SunPath2D3/PathFollow2D/Area2D/CollisionShape2D
onready var respawn_sun_timer := $RespawnSunTimer

onready var center_point := Vector2.ZERO
onready var start_point := Vector2(149, -10)
var target_point: Vector2
var fire_spinning = false
var spin_direction = 1
var nr_of_suns: int = 0
var player: Player
var max_idle_time = 6
var invincable = true

func _ready():
	Events.connect("damage_boss", self, "_on_damage_boss")
	Events.connect("boss_died", self, "_on_boss_died")
	_speed = SPEED
	max_idle_time = 6
	enter_enter()
	
func _physics_process(delta):
	match state:
		IDLE:
			update_idle(delta)
		FIRE_SPIN:
			update_fire_spin(delta)
		FIRE:
			update_fire(delta)
		CHASE:
			update_chase(delta)
		ENTER:
			update_enter()

# Enter -----------------------------------
func enter_enter():
	update_suns()
	state = ENTER
	sprite.animation = "Idle"
	hurt_animation_player.play("Burn")
	target_point = start_point
	travel_to(target_point)
	
func enter_idle():
	state = IDLE
	_speed = SPEED
	sprite.animation = "Idle"
	if nr_of_suns == 0:
		idle_timer.wait_time = rand_range(0, 1)
	else:
		idle_timer.wait_time = rand_range(2, max_idle_time)
	idle_timer.start()
	face_direction()

func enter_fire_spin():
	state = FIRE_SPIN
	sprite.animation = "Idle"
	fire_spin_area.rotation = 0
	travel_to(center_point)
	var rand = rand_range(-1, 1)
	if rand < 0:
		spin_direction = -1
	else:
		spin_direction = 1
	
func enter_fire():
	AudioManager.play_ra_chant2()
	state = FIRE
	sprite.animation = "Fire"
	
	var sunball = SUNBALL.instance()
	get_parent().call_deferred("add_child", sunball)
	sunball.position = sunball_shoot_position()
	nr_of_suns -= 1
	update_suns()
	
	player = Events.player
	if (player != null):
		var direction = (Events.player.global_position - sunball.position).normalized()
		target_point = player.global_position
		face_direction()
		sunball.call_deferred("set_direction", direction)

func enter_chase():
	_speed = SPEED * 2
	state = CHASE
	sprite.animation = "Idle"
	
	player = Events.player
	if player != null:
		target_point = player.global_position
		travel_to(target_point)
		face_direction()
	else: 
		enter_idle()
	
# Exit -----------------------------------
func exit_fire_spin():
	toggle_fire_spinner(false)
	fire_spinner_collider.set_deferred("disabled", true)
	animation_player.playback_speed = 1
	respawn_sun_timer.start()

# Updates -----------------------------------
func update_idle(delta):
	pass

func update_fire_spin(delta):
	if fire_spinning:
		fire_spin_area.rotation += delta * .9 * spin_direction

func update_fire(delta):
	pass

func update_chase(delta):
	var distance := global_transform.origin.distance_to(target_point)
	if distance < 10:
		enter_idle()

func update_enter():
	var distance := global_transform.origin.distance_to(target_point)
	if distance < 10:
		hurt_animation_player.play("RESET")
		nr_of_suns = 1
		respawn_sun_timer.start()
		invincable = false
		AudioManager.play_ra_chant3()
		enter_idle()

# Helpers -----------------------------------
func toggle_fire_spinner(on: bool):
	if on:
		fire_spinner_sun.animation = "Burn"
		hurt_animation_player.play("Burn")
	else:
		fire_spinner_sun.animation = "default"
		hurt_animation_player.play("RESET")
	invincable = on
	fire_spinner_particles1.emitting = on
	fire_spinner_particles2.emitting = on

func travel_to(point):
	tween.stop_all()
	var distance = global_position.distance_to(point)
	var duration = distance / _speed
	tween.interpolate_property(self, "global_position", global_position, point, duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func on_shot():
	if invincable: return
	Events.emit_signal("damage_boss")

func update_suns():
	match nr_of_suns:
		0:
			sun1.hide()
			sun1_collider.set_deferred("disabled", true)
			sun2.hide()
			sun2_collider.set_deferred("disabled", true)
			sun3.hide()
			sun3_collider.set_deferred("disabled", true)
		1:
			sun1.show()
			sun1_collider.set_deferred("disabled", false)
			sun2.hide()
			sun2_collider.set_deferred("disabled", true)
			sun3.hide()
			sun3_collider.set_deferred("disabled", true)
		2:
			sun1.show()
			sun1_collider.set_deferred("disabled", false)
			sun2.show()
			sun2_collider.set_deferred("disabled", false)
			sun3.hide()
			sun3_collider.set_deferred("disabled", true)
		3:
			sun1.show()
			sun1_collider.set_deferred("disabled", false)
			sun2.show()
			sun2_collider.set_deferred("disabled", false)
			sun3.show()
			sun3_collider.set_deferred("disabled", false)

func sunball_shoot_position() -> Vector2:
	match nr_of_suns:
		0:
			return sun1.global_position
		1:
			return sun1.global_position
		2:
			return sun2.global_position
		3:
			return sun3.global_position
			
	return Vector2.ZERO

func face_direction():
	player = Events.player
	
	if player != null:
		if (player.global_position.x - global_position.x) > 0:
			sprite.scale.x = -1
		else:
			sprite.scale.x = 1
		return
	if (target_point.x - global_position.x) > 0:
		sprite.scale.x = -1
	else:
		sprite.scale.x = 1
		
# Signals -----------------------------------
func _on_damage_boss():
	if invincable: return
	AudioManager.play_ra_hurt()
	hurt_animation_player.play("Hurt")
	animation_player.playback_speed = min(animation_player.playback_speed + 2, 8)
	if Events.boss_hit_points < 6:
		max_idle_time = 3
	
func _on_IdleTimer_timeout():
	if nr_of_suns == 0:
		enter_fire_spin()
		return
	if nr_of_suns == 1:
		enter_fire()
		return
		
	var random = int(rand_range(1, 2 + 1))
	match random:
		1:
			enter_chase()
		2:
			enter_fire()

func _on_Tween_tween_all_completed():
	match state:
		FIRE_SPIN:
			sprite.animation = "FireSpin"
			AudioManager.play_ra_chant1()
			toggle_fire_spinner(true)
			fire_spin_timer.wait_time = 1.5
			fire_spin_timer.start()

func _on_FireSpinTimer_timeout():
	if not fire_spinning:
		fire_spinning = true
		fire_spinner_collider.set_deferred("disabled", false)
		fire_spin_timer.wait_time = 7
		fire_spin_timer.start()
	else:
		fire_spinning = false
		exit_fire_spin()
		enter_idle()

func _on_FireSpinnerArea_body_entered(body):
	if body is Player:
		player = body
		body.hurt()

func _on_AnimatedSprite_animation_finished():
	if state == FIRE:
		enter_idle()
		
func _on_Area2D_body_entered(body):
	if body is Player:
		player = body
		body.hurt()

func _on_RespawnSunTimer_timeout():
	if nr_of_suns == 3:
		return
	else:
		nr_of_suns += 1
		update_suns()
		respawn_sun_timer.start()

func _on_boss_died():
	AudioManager.play_ra_hurt()
	AudioManager.play_ra_chant1()
	queue_free()
