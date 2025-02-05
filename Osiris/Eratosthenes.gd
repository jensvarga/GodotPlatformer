extends KinematicBody2D

class_name Eratosthenes

const MUSIC := preload("res://Sound/Music/Original/Deflemask/LibraryArsonist.wav")
const SWISH := preload("res://Sound/FX/MISC/robo_swish.wav")
const HURT := preload("res://Sound/FX/MISC/coptic_hurt.wav")
const ATTACK := preload("res://Sound/FX/MISC/coptic_attack.wav")
const DIE := preload("res://Sound/FX/MISC/coptic_die.wav")

const BOOK := preload("res://BookProjectile.tscn")
const FIRE := preload("res://BookFire.tscn")

const FLY_SPEED = 150

onready var sprite := $AnimatedSprite
onready var iframes_timer := $IFramesTimer
onready var animation_player := $AnimationPlayer
onready var idle_timer := $IdleTimer
onready var fire_timer := $FireTimer
onready var fire_position_1 := $FirePosition
onready var fire_position_2 := $FirePosition2
onready var fire_part_1 := $FireParticles
onready var fire_part_2 := $FireParticles2

onready var fire_array_1 := [
	$FireArray1/Position2D,
	$FireArray1/Position2D2,
	$FireArray1/Position2D3,
	$FireArray1/Position2D4,
	$FireArray1/Position2D5,
	$FireArray1/Position2D6,
	$FireArray1/Position2D7,
	$FireArray1/Position2D8,
	$FireArray1/Position2D9,
]

onready var fire_array_2 := [
	$FireArray2/Position2D,
	$FireArray2/Position2D2,
	$FireArray2/Position2D3,
	$FireArray2/Position2D4,
	$FireArray2/Position2D5,
	$FireArray2/Position2D6,
	$FireArray2/Position2D7,
	$FireArray2/Position2D8,
	$FireArray2/Position2D9
]

enum STATE {ENTER, IDLE, SWOOP, FLY_OFFSCREEN, FIRE_WAVE, DEAD}
var state = STATE.ENTER

var invincible = true
var velocity = Vector2.ZERO
var off_screne_position = Vector2(0, -175)
var target_position : Vector2
var start_position : Vector2
var last_attack
var first = true

func _ready():
	Events.connect("boss_died", self, "_on_boss_died")
	start_position = global_position
	enter_enter()

func _physics_process(delta):
	match state:
		STATE.ENTER:
			update_enter()
		STATE.IDLE:
			update_idle()
		STATE.FLY_OFFSCREEN:
			update_fly_offscreen()
		STATE.SWOOP:
			update_swoop()
		STATE.FIRE_WAVE:
			update_fire_wave()
		STATE.DEAD:
			position.y -= 10 * delta
			rotation += 0.5 * delta

func enter_fire_wave():
	state = STATE.FIRE_WAVE
	sprite.animation = "Fire"
	
	spawn_fire_sequence()

func spawn_fire_sequence():
	for i in range(fire_array_1.size()):
		var fire1 = FIRE.instance()
		fire1.position = fire_array_1[i].global_position
		get_parent().call_deferred("add_child", fire1)

		var fire2 = FIRE.instance()
		fire2.position = fire_array_2[i].global_position
		get_parent().call_deferred("add_child", fire2)

		yield(get_tree().create_timer(0.25), "timeout")
	
	if state != STATE.DEAD:
		enter_idle()

func update_fire_wave():
	pass

func enter_enter():
	state = STATE.ENTER
	sprite.animation = "Fly"
	if first:
		position = start_position
		first = false
	else:
		var rand = rand_range(-1, 1)
		if rand <= 0:
			position = start_position
			sprite.flip_h = false
		else:
			position = Vector2(-300, -200)
			sprite.flip_h = true
			
	AudioManager.play_sound(SWISH)

func update_enter():
	if is_on_floor():
		start_fight()
	
	if sprite.flip_h:
		velocity = Vector2(.5, 1)
	else:
		velocity = Vector2(-.5, 1)
	velocity = move_and_slide(velocity * FLY_SPEED, Vector2.UP)
	
func enter_idle():
	state = STATE.IDLE
	sprite.animation = "Idle"
	invincible = false
	idle_timer.wait_time = rand_range(0, 2)
	idle_timer.start()

func update_idle():
	pass

func enter_fly_offscreen():
	AudioManager.play_sound(SWISH)
	state = STATE.FLY_OFFSCREEN
	sprite.animation = "Fly"

func update_fly_offscreen():
	if off_screne_position.distance_squared_to(position) < 4:
		enter_swoop()
	var direction = (off_screne_position - position).normalized()
	velocity = direction * FLY_SPEED
	velocity = move_and_slide(velocity, Vector2.UP)

func enter_swoop():
	AudioManager.play_sound(SWISH)
	state = STATE.SWOOP
	var start_pos_1 := Vector2(300, -75)
	var target_pos_1 := Vector2(-300, -50)
	
	var start_pos_2 := Vector2(-300, -70)
	var target_pos_2 := Vector2(300, -50)
	
	var rand = rand_range(-1, 1)
	if rand < 0:
		position = start_pos_1
		target_position = target_pos_1
		sprite.flip_h = false
	else:
		position = start_pos_2
		target_position = target_pos_2
		sprite.flip_h = true
	
	fire_timer.start()

func update_swoop():
	if target_position.distance_squared_to(position) < 4:
		enter_enter()
	
	var direction = (target_position - position).normalized()
	velocity = direction * FLY_SPEED
	velocity = move_and_slide(velocity, Vector2.UP)

func on_shot():
	if not invincible and state != STATE.DEAD:
		Events.emit_signal("damage_boss")
		
		if (Events.boss_hit_points - 1) <= 0:
			pass
		else:
			animation_player.play("Hurt")
			AudioManager.play_sound(HURT)
			invincible = true
			iframes_timer.start()

func start_fight():
	AudioManager.play_boom()
	if not AudioManager.music_playing:
		AudioManager.play_music(MUSIC)
	enter_idle()

func _on_boss_died():
		state = STATE.DEAD
		sprite.animation = "Die"
		animation_player.play("Die")
		AudioManager.play_sound(DIE)
		AudioManager.play_boom()
		CameraShaker.call_deferred("add_trauma", 0.4)
		AudioManager.stop_music()
		idle_timer.stop()
		iframes_timer.stop()
		fire_timer.stop()
		fire_part_1.emitting = true
		fire_part_2.emitting = true
		
func _on_IFramesTimer_timeout():
	invincible = false

func _on_IdleTimer_timeout():
	if state == STATE.DEAD:
		return
	random_attack()

func random_attack():
	if state == STATE.DEAD:
		return
		
	var nr_of_attacks := 2
	var random = last_attack
	while random == last_attack:
		 random = int(rand_range(1, nr_of_attacks + 1))
	
	match random:
		1:
			enter_fly_offscreen()
		2:
			enter_fire_wave()
	
	last_attack = random

func _on_FireTimer_timeout():
	var fire_pos = fire_position_1.global_position
	if sprite.flip_h:
		fire_pos = fire_position_2.global_position
		
	var book := BOOK.instance()
	var target = Events.player.global_position
	var direction = (target - fire_pos).normalized()
	book.position = fire_pos
	book.call_deferred("set_direction", direction,  direction.angle())
	get_parent().call_deferred("add_child", book)
	
	if state == STATE.SWOOP:
		fire_timer.start()

func _on_VisibilityNotifier2D_screen_exited():
	if state == STATE.DEAD:
		call_deferred("queue_free")
