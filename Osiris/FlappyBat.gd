extends KinematicBody2D

const AMPLITUDE = 30
const FREQUENCY = 2.0
const SPLAT := preload("res://BirdSplat.tscn")

onready var sprite := $AnimatedSprite
onready var raycast := $RayCast2D
onready var idle_timer := $IdleTimer
onready var flip_timer := $FlipTimer
onready var speed = 100 + rand_range(-50, 50) 

enum State { IDLE, FLY }
var state = State.IDLE

var offset = randf() * PI * 2
var velocity = Vector2.ZERO 
var direction = 1

func _ready():
	direction = scale.x
	enter_fly()

func _physics_process(delta):
	match state:
		State.IDLE:
			update_idle()
		State.FLY:
			update_fly(delta)

func enter_idle():
	state = State.IDLE
	sprite.animation = "Idle"
	idle_timer.start()
	scale.x *= -1
	direction *= -1

func enter_fly():
	state = State.FLY
	sprite.animation = "Fly"
	offset = randf() * PI * 2
	flip_timer.wait_time = rand_range(1, 5)
	flip_timer.start()

func update_idle():
	if not raycast.is_colliding():
		enter_fly()

func update_fly(delta):
	var forward_movement = Vector2(speed * direction, 0)
	var bobbing_movement = Vector2(0, sin((OS.get_ticks_msec() / 1000.0) * FREQUENCY + offset) * AMPLITUDE)
	var movement = forward_movement + bobbing_movement
	velocity = move_and_slide(movement, Vector2.UP)
	
	if raycast.is_colliding():
		enter_idle()

func flip_direction():
	scale.x *= -1
	direction *= -1

func on_shot():
	AudioManager.play_random_hit_sound()
	var splat := SPLAT.instance()
	get_parent().call_deferred("add_child", splat)
	splat.position = global_position
	call_deferred("queue_free")
	
func _on_IdleTimer_timeout():
	enter_fly()

func _on_Area2D_body_entered(body):
	if body is Player:
		body.hurt()
		body.bounce(100)

func _on_FlipTimer_timeout():
	if state == State.FLY:
		flip_direction()
		flip_timer.wait_time = rand_range(1, 5)
		flip_timer.start()
