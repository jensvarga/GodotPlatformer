extends KinematicBody2D

const WALK_SPEED := 60
const GRAVITY := 540
const JUMP_SPEED := 200

const SWISH := preload("res://Sound/FX/MISC/robo_swish.wav")
const SPLASH := preload("res://GreenSplash.tscn")

enum STATE {IDLE, WALK, JUMP, RALLY}
var state = STATE.IDLE

onready var sprite := $AnimatedSprite
onready var idle_timer := $IdleTimer
onready var walk_timer := $WalkTimer
onready var detection_area := $DetectionArea
onready var ray := $RayCast2D
onready var rally_timer := $RallyTimer
onready var detection_shape := $DetectionArea/CollisionShape2D
onready var animation_player := $AnimationPlayer
onready var ground_detector := $GroundDetectionNode/GroundDetection
onready var ground_detetor_node := $GroundDetectionNode

var velocity := Vector2.ZERO
var direction := -1
var jump_position: Vector2
var first_frame = true
var hp = 2

func _ready():
	enter_idle()

func _physics_process(delta):
	match state:
		STATE.IDLE:
			pass
		STATE.WALK:
			update_walk(delta)
		STATE.JUMP:
			update_jump(delta)
		STATE.RALLY:
			pass
	
	flip_sprite()

func enter_idle():
	state = STATE.IDLE
	sprite.animation = "Idle"
	idle_timer.wait_time = rand_range(2, 5)
	idle_timer.start()
	velocity.x = 0

func enter_walk():
	state = STATE.WALK
	sprite.animation = "Walk"
	walk_timer.wait_time = rand_range(1, 3)
	walk_timer.start()
	direction = 1 if randi() % 2 == 0 else -1

func enter_jump():
	state = STATE.JUMP
	sprite.animation = "Jump"
	AudioManager.play_sound(SWISH)
	
	var jump_direction = (jump_position - global_position).normalized()
	var distance = global_position.distance_to(jump_position)
	if jump_direction.x > 0:
		direction = 1
	else:
		direction = -1
	
	velocity.x = jump_direction.x * JUMP_SPEED
	velocity.y = -sqrt(2 * GRAVITY * (distance / 3))

func enter_rally():
	state = STATE.RALLY
	sprite.animation = "Idle"
	detection_shape.set_deferred("disabled", true)
	rally_timer.start()
	velocity.x = 0
	first_frame = true

func update_jump(delta):
	if is_on_floor() and not first_frame:
		enter_rally()
		return
	velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	if first_frame:
		first_frame = false

func update_walk(delta):
	if is_on_wall() or not ground_detector.is_colliding():
		direction *= -1
			
	velocity.x = direction * WALK_SPEED
	velocity.y += GRAVITY * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)

func flip_sprite():
	if direction > 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
		
	detection_area.scale.x = direction
	ground_detetor_node.scale.x = direction

func _on_IdleTimer_timeout():
	if state == STATE.IDLE:
		enter_walk()

func _on_WalkTimer_timeout():
	if state == STATE.WALK:
		enter_idle()

func _on_Area2D_body_entered(body):
	if body is Player:
		body.hurt()

func _on_DetectionArea_body_entered(body):
	if body is Player and state != STATE.JUMP:
		ray.enabled = true
		var pos = body.global_position - global_position
		ray.cast_to = pos
		ray.force_raycast_update()
		
		if not ray.is_colliding():
			ray.enabled = false
			jump_position = body.global_position
			enter_jump()

func _on_RallyTimer_timeout():
	if state == STATE.RALLY:
		detection_shape.set_deferred("disabled", false)
		enter_idle()

func _on_RetriggerTimer_timeout():
	detection_shape.set_deferred("disabled", true)
	detection_shape.set_deferred("disabled", false)

func on_shot():
	if hp - 1 <= 0:
		die()
	else:
		animation_player.play("Hurt")
		hp -= 1

func die():
	var splash := SPLASH.instance()
	get_parent().call_deferred("add_child", splash)
	splash.set_deferred("position", global_position)
	AudioManager.play_boom()
	call_deferred("queue_free")
