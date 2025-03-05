extends KinematicBody2D

onready var animation_player := $AnimationPlayer
onready var sprite := $AnimatedSprite

# Colliders
onready var body_collider := $CollisionPolygon2D
onready var head_collider := $HeadArea/HeadCollider
onready var dive_collider := $HeadArea/DiveCollider

# Timers
onready var idle_timer := $IdleTimer
onready var invincibility_timer := $InvincibilityTimer

signal BiteAttack
signal BiteAttackDone
signal SnakeAttack
signal SnakeAttackDone

var velocity = Vector2.ZERO
enum State {Intro, Idle, Dive, BiteAttack, Return, Dead, SnakeAttack}
var state = State.Idle
var start_position := Vector2.ZERO
var first = true
var last_attack
var invincible = true

func _ready():
	connect("BiteAttackDone", self, "_on_BiteAttackDone")
	connect("SnakeAttackDone", self, "_on_SnakeAttackDone")
	head_collider.set_deferred("disabled", false)
	body_collider.set_deferred("disabled", false)
	dive_collider.set_deferred("disabled", true)

func _physics_process(delta):
	match state:
		State.Intro:
			pass
		State.Idle:
			pass
		State.Dive:
			update_dive(delta)
		State.BiteAttack:
			pass
		State.Return:
			update_return(delta)
		State.SnakeAttack:
			pass
		State.Dead:
			pass

func enter_intro():
	invincible = true
	state = State.Intro
	sprite.animation = "Idle"
	animation_player.play("Intro")
	
func enter_idle():
	state = State.Idle
	sprite.animation = "Idle"
	invincible = false
	animation_player.play("EnterIdle")
	head_collider.set_deferred("disabled", false)
	body_collider.set_deferred("disabled", false)
	dive_collider.set_deferred("disabled", true)
	velocity = Vector2.ZERO
	idle_timer.wait_time = rand_range(1, 3)
	idle_timer.start()
	if first:
		start_position = global_position
		first = false

func enter_dive():
	head_collider.set_deferred("disabled", true)
	body_collider.set_deferred("disabled", true)
	state = State.Dive
	sprite.animation = "Dive"
	AudioManager.play_aphopis_bite_sound()

func enter_return():
	invincible = false
	state = State.Return
	head_collider.set_deferred("disabled", false)
	sprite.animation = "Idle"

func enter_bite_attack():
	state = State.BiteAttack
	emit_signal("BiteAttack")

func enter_snake_attack():
	state = State.SnakeAttack
	emit_signal("SnakeAttack")

func update_dive(delta):
	if global_position.y > (start_position.y + 300):
		velocity.y = 0
		random_attack()
		return
		
	velocity.y += 100 * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if sprite.frame == 2:
		CameraShaker.add_trauma(0.5)
		dive_collider.set_deferred("disabled", false)
	
	if sprite.frame == 11:
		sprite.frame = 3

func update_return(delta):
	if global_position.y <= 0:
		enter_idle()
		return
		
	velocity.y -= 50 * delta
	velocity = move_and_slide(velocity, Vector2.UP)

func random_attack():
	if state == State.Dead:
		return
		
	var nr_of_attacks := 2
	var random = last_attack
	while random == last_attack:
		 random = int(rand_range(1, nr_of_attacks + 1))
	
	match random:
		1:
			enter_bite_attack()
		2:
			enter_snake_attack()
	
	last_attack = random

func _on_IdleTimer_timeout():
	enter_dive()

func _on_BiteAttackDone():
	enter_return()

func _on_SnakeAttackDone():
	enter_return()

func hurt():
	if not invincible:
		if (Events.boss_hit_points - 1) > 0:
			Events.emit_signal("damage_boss")
			animation_player.play("Hurt")
			AudioManager.play_aphopis_hurt_sound()
			
		invincible = true
		invincibility_timer.start()

func _on_InvincibilityTimer_timeout():
	invincible = false

func _on_HeadArea_body_entered(body):
	if body is Player:
		body.hurt()
		body.bounce(200)
