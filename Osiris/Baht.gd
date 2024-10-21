extends KinematicBody2D
class_name Baht

const GRAVITY = 540
const BLOB := preload("res://BahtBlob.tscn")
const ARMOR_PART := preload("res://BahtArmorParticles.tscn")
const BAHT_BALL := preload("res://BahtBall.tscn")
const BODY := preload("res://DyingBaht.tscn")

signal slime_returned
signal flash
var slimes_returned = 0

onready var sprite := $AnimatedSprite
onready var blob_spawn_pos := $BlobSpawnPosition
onready var suck_particles := $SuckPatricles
onready var animation_player := $AnimationPlayer
onready var fire_pos := $FirePosition
onready var hoover_timer := $HooverTimer
onready var idle_timer := $IdleTimer
onready var telegraph_timer := $TelegraphTimer
onready var hurt_timer := $HurtTimer
onready var fire_timer := $FireTimer
onready var censor_bar_1 := $AnimatedSprite/CensorBar
onready var censor_bar_2 := $AnimatedSprite/CensorBar2

enum State { IDLE, HOOVER, FALL, TELEGRAPH, HYPNO, RESET, FIRE, DEAD }

var state = State.IDLE
var velocity = Vector2.ZERO
var event_node: Node2D
var vunerable = false
var invincable = false

# initializers
func set_event_node(node: Node2D):
	self.event_node = node
	
	if event_node.slime_count >= 4:
		enter_reset()

func _ready():
	connect("slime_returned", self, "_on_slime_returned")
	Events.connect("boss_died", self, "_on_boss_died")
	enter_hoover()
	if Events.family_friendly_mode:
		censor_bar_2.show()

func _physics_process(delta):
	match state:
		State.IDLE:
			update_idle()
		State.HOOVER:
			update_hoover()
		State.FALL:
			update_fall(delta)
		State.TELEGRAPH:
			pass
		State.HYPNO:
			pass
		State.RESET:
			pass
		State.FIRE:
			pass

# Enter state
func enter_idle():
	state = State.IDLE
	if vunerable:
		censor(true)
		sprite.animation = "VunerableIdle"
	else:
		sprite.animation = "Idle"
		censor(false)
	sprite.material.set("shader_param/active_bob", false)
	idle_timer.wait_time = rand_range(.5, 2)
	idle_timer.start()

func enter_hoover():
	state = State.HOOVER
	sprite.animation = "Hoover"
	sprite.material.set("shader_param/active_bob", true)
	hoover_timer.wait_time = rand_range(2, 5)
	hoover_timer.start()

func enter_fall():
	state = State.FALL
	sprite.animation = "Fall"
	sprite.material.set("shader_param/active_bob", true)

func enter_telegraph():
	state = State.TELEGRAPH
	if vunerable:
		censor(true)
		sprite.animation = "VunerableTelegraph"
		spawn_blob()
	else:
		sprite.animation = "Telegraph"
		censor(false)
	telegraph_timer.start()
	sprite.material.set("shader_param/active_bob", false)
	
func enter_fire():
	state = State.FIRE
	sprite.animation = "VunerableHypno"
	censor(true)
	fire_timer.start()

func enter_hypno():
	state = State.HYPNO
	if vunerable:
		censor(true)
		sprite.animation = "VunerableHypno"
	else:
		sprite.animation = "Hypno"
		censor(false)
	sprite.material.set("shader_param/active_bob", false)
	if event_node.has_method("hypno_attack"):
		event_node.hypno_attack()

func enter_reset():
	AudioManager.play_baht_suck()
	stop_all_timers()
	state = State.RESET
	censor(true)
	sprite.animation = "Reset"
	sprite.material.set("shader_param/active_bob", true)
	event_node.set_deferred("slime_count", 0)
	event_node.reset_attack()
	suck_particles_on()
	
func enter_dead():
	state = State.DEAD
	stop_all_timers()
	AudioManager.play_baht_die()
	var body = BODY.instance()
	get_parent().call_deferred("add_child", body)
	body.position = global_position
	AudioManager.stop_music()
	call_deferred("queue_free")
	
# Update state
func update_hoover():
	pass

func update_fall(delta):
	apply_gravity(delta)
	
	if is_on_floor():
		CameraShaker.call_deferred("add_trauma", 0.5)
		AudioManager.play_boom()
		if vunerable:
			spawn_armor_particles()
		idle_or_fire()
	
	velocity = move_and_slide(velocity, Vector2.UP)

func update_idle():
	pass

# Helpers
func idle_or_fire():
	if Events.boss_hit_points < 6:
		var i = randi() % 3 - 1
		if i > 0:
			enter_fire()
		else:
			enter_idle()
	else:
		enter_idle()
		
func apply_gravity(delta):
	velocity.y += GRAVITY * delta

func spawn_blob():
	var blob = BLOB.instance()
	event_node.slimes_node.call_deferred("add_child", blob)
	blob.position = blob_spawn_pos.global_position
	event_node.slime_count += 1

func spawn_armor_particles():
	var parts := ARMOR_PART.instance()
	get_parent().call_deferred("add_child", parts)
	parts.position = global_position

func _hurt():
	AudioManager.play_random_baht_moan()
	AudioManager.play_random_hit_sound()
	animation_player.play("Hurt")
	Events.emit_signal("damage_boss")
	emit_signal("flash")
	invincable = true
	hurt_timer.start()
	if state == State.IDLE:
		stop_all_timers()
		enter_telegraph()
		return
	if state == State.TELEGRAPH:
		stop_all_timers()
		enter_hypno()
		return

func stop_all_timers():
	hoover_timer.stop()
	idle_timer.stop()
	telegraph_timer.stop()

func ball_spiral():
	var num_balls = 20
	
	for i in range(num_balls):
		var angle = (i * (2 * PI / num_balls))
	
		var dir = Vector2(cos(angle), sin(angle))
		fire_ball(dir)
		yield(get_tree().create_timer(.05), "timeout")
	
	enter_fall()

func fire_ball(dir: Vector2):
	AudioManager.play_baht_fire()
	var ball := BAHT_BALL.instance()
	get_parent().call_deferred("add_child", ball)
	ball.call_deferred("set_direction", dir)
	ball.set_deferred("position", fire_pos.global_position)

func suck_particles_on():
	for suck in suck_particles.get_children():
		suck.emitting = true

func suck_particles_off():
	for suck in suck_particles.get_children():
		suck.emitting = false
	
# Signals
func on_shot():
	if (state == State.IDLE or state == State.TELEGRAPH) and vunerable:
		_hurt()
	else:
		AudioManager.play_ding()

func censor(on: bool):
	if not Events.family_friendly_mode:
		return
	if on:
		censor_bar_1.show()
	else:
		censor_bar_1.hide()
		
func _on_HooverTimer_timeout():
	if event_node.slime_count < 4:
		enter_fall()
	else:
		pass

func _on_IdleTimer_timeout():
	enter_telegraph()

func _on_TelegraphTimer_timeout():
	enter_hypno()

func _on_Area2D_body_entered(body):
	if body is Player:
		body.hurt()
		var value = -2 if randf() < 0.5 else 2
		var dir = Vector2(value, -1).normalized()
		body.knockback(dir * 200)

func _on_HurtTimer_timeout():
	invincable = false

func _on_slime_returned():
	slimes_returned += 1
	if slimes_returned > 3:
		slimes_returned = 0
		suck_particles_off()
		ball_spiral()

func _on_FireTimer_timeout():
	var dir = (Events.player.global_position - fire_pos.global_position).normalized()
	fire_ball(dir)
	enter_telegraph()

func _on_boss_died():
	enter_dead()

