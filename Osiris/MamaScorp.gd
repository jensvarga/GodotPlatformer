class_name MamaScorp
extends KinematicBody2D

const SCORP_BALL = preload("res://ScorpBall.tscn")
const EXPLO = preload("res://Explosion1.tscn")
const SPEED = 10
const THROW_SPEED = 100

var hp = 5

onready var throw_position := $ThrowPosition
onready var sprite := $AnimatedSprite
onready var animation_timer := $AnimationTimer
onready var animation_player := $AnimationPlayer
onready var throw_timer := $ThrowTimer

var right_pos = Vector2.ZERO
var left_pos = Vector2.ZERO

var move_left = false
var velocity = Vector2.ZERO

func _ready():
	animation_player.play("RESET")
	right_pos = Vector2(global_position.x + 10, global_position.y)
	left_pos = Vector2(global_position.x - 10, global_position.y)
	sprite.animation = "Walk"

func _physics_process(delta):
	if move_left:
		velocity.x = -SPEED
		if global_position.x <= left_pos.x:
			move_left = false
	else:
		velocity.x = SPEED
		if global_position.x >= right_pos.x:
			move_left = true
				
	velocity = move_and_slide(velocity, Vector2.UP)

func throw_egg():
	sprite.animation = "Throw"
	animation_timer.start()
	var player_position = Events.player.global_position
	var start_position = throw_position.global_position
	
	var scorp_ball = SCORP_BALL.instance()
	scorp_ball.position = start_position
	get_parent().call_deferred("add_child", scorp_ball)
	
	var direction = (player_position - start_position).normalized()
	var throw_velocity = direction * THROW_SPEED
	throw_velocity.y -= THROW_SPEED
	scorp_ball.set_deferred("linear_velocity", throw_velocity)
	
	throw_timer.start()

func die():
	AudioManager.play_boom()
	var explo = EXPLO.instance()
	get_parent().call_deferred("add_child", explo)
	explo.position = global_position
	queue_free()

func damage():
	hp -= 1
	animation_player.play("Hurt")

func on_shot():
	if (hp - 1) < 1:
		die()
	else:
		damage()

func _on_ThrowTimer_timeout():
	throw_egg()

func _on_TurnArea_body_entered(body):
	if body is Player:
		scale.x *= -1

func _on_AnimationTimer_timeout():
	sprite.animation = "Walk"

func _on_VisibilityEnabler2D_screen_entered():
	throw_timer.start()

func _on_VisibilityEnabler2D_screen_exited():
	throw_timer.stop()

func _on_Area2D_body_entered(body):
	if body is Player:
		var dir = (body.global_position - global_position).normalized()
		body.knockback(dir * 200)
		body.hurt()
