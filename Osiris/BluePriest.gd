extends StaticBody2D

class_name BluePriest

onready var sprite := $AnimatedSprite
onready var fire_pos := $Position2D
onready var idle_timer := $IdleTimer
onready var animation_player := $AnimationPlayer

const FIREBALL := preload("res://BennuFireball.tscn")
const SPLASH := preload("res://GreenSplash.tscn")

enum { IDLE, SHOOT }
var state = IDLE
var has_fired = false

var hp = 2

func _ready():
	animation_player.play("RESET")
	enter_idle()

func _physics_process(delta):
	match state:
		IDLE:
			pass
		SHOOT:
			update_shoot()

func enter_idle():
	state = IDLE
	sprite.animation = "Idle"
	idle_timer.start()

func enter_shoot():
	state = SHOOT
	sprite.animation = "Shoot"
	has_fired = false

func update_shoot():
	if sprite.frame == 1 and not has_fired:
		shoot()
		has_fired = true
		
func shoot():
	var fireball := FIREBALL.instance()
	get_parent().call_deferred("add_child", fireball)
	fireball.position = fire_pos.global_position
	fireball.call_deferred("set_direction", Vector2(-scale.x, 0), 0, 0)
	fireball.call_deferred("set_hue", 0.3)
	
	var fireball2 := FIREBALL.instance()
	get_parent().call_deferred("add_child", fireball2)
	fireball2.position = fire_pos.global_position
	fireball2.call_deferred("set_direction", Vector2(-scale.x, .5), -23, 0)
	fireball2.call_deferred("set_hue", 0.3)
	
	var fireball3 := FIREBALL.instance()
	get_parent().call_deferred("add_child", fireball3)
	fireball3.position = fire_pos.global_position
	fireball3.call_deferred("set_direction", Vector2(-scale.x, -.5), 23, 0)
	fireball3.call_deferred("set_hue", 0.3)
	AudioManager.play_random_explosion_sound()

func die():
	var splash := SPLASH.instance()
	get_parent().call_deferred("add_child", splash)
	splash.set_deferred("position", global_position)
	AudioManager.play_boom()
	queue_free()

func on_shot():
	if (hp - 1) < 1:
		die()
	else:
		hp -= 1
		animation_player.play("Hurt")
		
func _on_AnimatedSprite_animation_finished():
	if state == SHOOT:
		enter_idle()

func _on_IdleTimer_timeout():
	enter_shoot()

func _on_TurnArea_body_entered(body):
	if body is Player:
		scale.x *= -1

