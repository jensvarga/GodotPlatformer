extends KinematicBody2D

class_name TerrorBird

const BIRD_SPLAT = preload("res://BirdSplat.tscn")
const MOVE_SPEED = 200
const GRAVITY = 540
const DECELERATION = 500
const JUMP_FORCE = -250
var velocity = Vector2()
var direction: float = 1

var hp = 5

enum { IDLE, ALERT, CHASE, ATTACK, PLAYER_DEAD }

onready var sprite := $AnimatedSprite
onready var alert_timer := $AlertTimer
onready var damage_shape := $AttackArea2/CollisionShape2D
onready var player_detector_shape := $PlayerDetection/CollisionPolygon2D
onready var animation_player := $AnimationPlayer
onready var idle_timer := $IdleTimer
onready var wall_detection := $RayCast2D
onready var jump_height := $JumpHeight
onready var line_of_sight := $LineOfSight

var state = IDLE

var player: Player = null
var is_jumping = false

func _ready():
	Events.connect("player_died", self, "_on_player_died")
	enter_idle()
	
func _physics_process(delta):
	match state:
		IDLE:
			update_idle(delta)
		ALERT:
			update_alert(delta)
		CHASE:
			update_chase(delta)
		ATTACK:
			update_attack(delta)
		PLAYER_DEAD:
			pass
			
func enter_player_dead():
	state = PLAYER_DEAD
	sprite.animation = "Idle"
	
func enter_idle():
	damage_shape.set_deferred("disabled", true)
	player_detector_shape.set_deferred("disabled", false)
	velocity.x = 0
	state = IDLE
	sprite.animation = "Idle"
	idle_timer.wait_time = rand_range(2, 7)
	idle_timer.start()

func enter_alert():
	velocity.x = 0
	state = ALERT
	sprite.animation = "Alert"
	alert_timer.start()
	AudioManager.play_terror_bird_alert()

func enter_chase():
	state = CHASE
	sprite.animation = "Run"

func enter_attack():
	state = ATTACK
	sprite.animation = "Attack"
	player_detector_shape.set_deferred("disabled", true)

func exit_attack():
	damage_shape.set_deferred("disabled", true)
	
func update_chase(delta):
	if player == null:
		enter_idle()
		
	var direction = (player.global_position - global_position).normalized()
	velocity.x = direction.x * MOVE_SPEED
	
	if is_jumping or not is_on_floor():
		apply_gravity(delta)

	if not is_jumping and wall_detection.is_colliding() and jump_height.is_colliding():
		is_jumping = true
		velocity.y = JUMP_FORCE

	if is_jumping and not jump_height.is_colliding():
		is_jumping = true

	if not wall_detection.is_colliding():
		is_jumping = false  
		
	velocity = move_and_slide(velocity, Vector2.UP)
	face_player()

func apply_gravity(delta):
	velocity.y += GRAVITY * delta

func update_idle(delta):
	velocity.x = 0
	apply_gravity(delta)
	velocity = move_and_slide(velocity, Vector2.UP)

func update_alert(delta):
	apply_gravity(delta)
	velocity = move_and_slide(velocity, Vector2.UP)

func update_attack(delta):
	if sprite.frame == 1:
		damage_shape.set_deferred("disabled", false)
	else:
		damage_shape.set_deferred("disabled", true)
	
	apply_gravity(delta)
	velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)
	velocity = move_and_slide(velocity, Vector2.UP)
	face_player()

func face_player():
	var direction_to_player = (player.global_position - global_position).normalized()
	var distance_to_player = player.global_position.x - global_position.x
	
	var margin = 5.0
	if abs(distance_to_player) > margin:
		if direction_to_player.x * direction > 0:
			scale.x *= -1
			direction *= -1

func die():
	AudioManager.play_terror_bird_die()
	var bird_splat = BIRD_SPLAT.instance()
	get_parent().add_child(bird_splat)
	bird_splat.position = global_position
	queue_free()

func _on_PlayerDetection_body_entered(body):
	if line_of_sight.is_colliding():
		return
	if body is Player:
		player = body
		enter_alert()

func _on_AlertTimer_timeout():
	enter_chase()

func _on_VisibilityNotifier2D_screen_exited():
	enter_idle()

func _on_AttackArea_body_entered(body):
	if body is Player and state != ATTACK:
		enter_attack()

func _on_AttackArea2_body_entered(body):
	if body is Player and state == ATTACK:
		body.hurt()

func _on_AttackArea_body_exited(body):
	if body is Player:
		exit_attack()
		enter_idle()

func _on_player_died():
	enter_player_dead()

func on_shot():
	if (hp - 1) > 0:
		AudioManager.play_terror_bird_hurt()
		animation_player.play("Hurt")
		hp -= 1
		
		if state == IDLE:
			player = Events.player
			enter_alert()
	else: 
		die()

func _on_IdleTimer_timeout():
	if state == IDLE:
		scale.x *= -1
		direction *= -1
		idle_timer.wait_time = rand_range(2, 7)
		idle_timer.start()
