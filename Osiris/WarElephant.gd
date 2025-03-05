extends KinematicBody2D

const SPEED := 200
const GRAVITY := 540
const BODY = preload("res://DeadWarElephant.tscn")
const TRUMPET := preload("res://Sound/FX/MISC/elephant_trumpet.wav")
const TRUMPET_2 := preload("res://Sound/FX/MISC/elephant_trumpet_2.wav")

enum { PAUSE, IDLE, ATTACK, THRASH }
var state = IDLE
var velocity = Vector2.ZERO
export (int) var direction = -1
var hp: int = 15
var first = true

onready var sprite := $AnimatedSprite
onready var ray := $RayCast2D
onready var damgae_area := $Area2D
onready var thrash_timer := $ThrashTimer
onready var collidion_shape := $Area2D/CollisionShape2D
onready var detection_shape := $PlayerDetection/CollisionShape2D

var charge_position := Vector2.ZERO
var dead = false

func _ready():
	enter_idle()
	
func _physics_process(delta):
	match state:
		PAUSE:
			pass
		IDLE:
			update_idle(delta)
		ATTACK:
			update_attack(delta)
		THRASH:
			update_thrash(delta)
	
func enter_idle():
	velocity.x = 0
	state = IDLE
	sprite.animation = "Idle"
	detection_shape.set_deferred("disabled", false)
	
func enter_attack():
	collidion_shape.set_deferred("disabled", false)
	AudioManager.play_random_sound([TRUMPET, TRUMPET_2])
	state = ATTACK
	sprite.animation = "Run"
	direction = global_position.direction_to(charge_position).x
	face_player()

func enter_thrash():
	velocity.x = 0
	state = THRASH
	sprite.animation = "Thrash"
	thrash_timer.start()
	detection_shape.set_deferred("disabled", true)
	
func update_idle(delta):
	velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
func update_thrash(delta):
	if sprite.frame == 1:
		collidion_shape.set_deferred("disabled", true)
	else:
		collidion_shape.set_deferred("disabled", false)
	
	velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2.UP)

func update_attack(delta):
	velocity.y += GRAVITY * delta
	velocity.x = direction * SPEED
	velocity = move_and_slide(velocity, Vector2.UP)

func on_shot():
	if hp - 1 <= 0:
		die()
	else:
		AudioManager.play_random_hit_sound()
		AudioManager.play_cow_moo()
		$AnimationPlayer.play("Hurt")
		hp -= 1
		if state == IDLE:
			if Events.player == null:
				return
			var dir := global_position.direction_to(Events.player.global_position)
			charge_position = Vector2(global_position.x + 20 * dir.x, global_position.y)
			enter_attack()

func die():
	if not dead:
		dead = true
		Events.emit_signal("killed_miniboss")
		AudioManager.play_random_fart()
		AudioManager.play_random_sound([TRUMPET, TRUMPET_2])
		var parts = BODY.instance()
		get_parent().call_deferred("add_child", parts)
		parts.position = global_position
		queue_free()

func face_player():
	if direction > 0:
		damgae_area.scale.x = -1
		sprite.flip_h = true
	else:
		damgae_area.scale.x = 1
		sprite.flip_h = false

func _on_PlayerDetection_body_entered(body):
	if body is Player and state == IDLE:
		ray.enabled = true
		var pos = body.global_position - global_position
		ray.cast_to = pos
		ray.force_raycast_update()
		
		if not ray.is_colliding():
			ray.enabled = false
			charge_position = body.global_position
			enter_attack()

func _on_PlayerDetection_body_exited(body):
	if state != THRASH:
		enter_thrash()

func _on_Area2D_body_entered(body):
	if body is Player:
		body.hurt()
		body.bounce(200)
		body.knockback(velocity)
		enter_thrash()

func _on_ThrashTimer_timeout():
	enter_idle()
