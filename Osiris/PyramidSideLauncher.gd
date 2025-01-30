extends KinematicBody2D

enum DIRECTION {LEFT, RIGHT}
export (DIRECTION) var direction = DIRECTION.LEFT

const MISSILE = preload("res://PyramidMissile.tscn")
const EXPLOSION = preload("res://Explosion1.tscn")

onready var top_pos := $TopPosition
onready var bottom_pos := $BottomPosition
onready var sprite := $AnimatedSprite
onready var fire_timer := $FireTimer
onready var idle_timer := $IdleTimer
onready var animation_player := $AnimationPlayer

var down := false
var started := false

var hp := 3

func telegraph_fire():
	down = not down
	
	if down:
		sprite.animation = "DownBlink"
	else:
		sprite.animation = "UpBlink"
	
	fire_timer.start()

func on_shot():
	if (hp - 1) <= 0:
		die()
		return
		
	hp = hp - 1
	animation_player.play("Hurt")

func die():
	AudioManager.play_random_explosion_sound()
	var explosion = EXPLOSION.instance()
	get_parent().call_deferred("add_child", explosion)
	explosion.position = global_position
	call_deferred("queue_free")

func _on_FireTimer_timeout():
	sprite.animation = "default"
	
	var fire_pos = top_pos
	if down:
		fire_pos = bottom_pos
		
	var missile = MISSILE.instance()
	var angle = 180
	if direction == DIRECTION.RIGHT:
		angle = 0
	var radian_angle = deg2rad(angle)
	
	var _direction = Vector2(cos(radian_angle), sin(radian_angle))
	
	missile.position = fire_pos.global_position
	missile.set_direction(_direction, radian_angle)
	get_parent().call_deferred("add_child", missile)
	
	if started:
		idle_timer.start()

func _on_IdleTimer_timeout():
	telegraph_fire()

func _on_Area2D_body_entered(body):
	if body is Player and not started:
		started = true
		telegraph_fire()

func _on_Area2D_body_exited(body):
	if body is Player and not started:
		started = false
		telegraph_fire()

func _on_VisibilityNotifier2D_screen_exited():
	started = false
