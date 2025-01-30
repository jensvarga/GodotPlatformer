extends Node2D

enum DIRECTION {UP, DOWN}
export (DIRECTION) var direction = DIRECTION.DOWN

const MISSILE = preload("res://PyramidMissile.tscn")
const EXPLOSION = preload("res://Explosion1.tscn")

onready var sprite := $AnimatedSprite
onready var launch_point := $LaunchPoint
onready var animation_player := $AnimationPlayer
onready var idle_timer := $IdleTimer

var hp = 3
var on = false

var directions = [
		-90,
		-45,
		0,
		45,
		90
	]

func _ready():
	sprite.animation = "default"

func die():
	AudioManager.play_random_explosion_sound()
	var explosion = EXPLOSION.instance()
	get_parent().call_deferred("add_child", explosion)
	explosion.position = launch_point.global_position
	call_deferred("queue_free")

func launch_missiles():
	for angle in directions:
		var missile = MISSILE.instance()
		
		var offset = 270
		if direction == DIRECTION.DOWN:
			offset = 90
		var radian_angle = deg2rad(angle + offset)
		
		var _direction = Vector2(cos(radian_angle), sin(radian_angle))
		
		missile.position = launch_point.global_position
		missile.set_direction(_direction, radian_angle)
		get_parent().call_deferred("add_child", missile)
	
	sprite.animation = "Fired"
	idle_timer.start()

func _on_AnimatedSprite_animation_finished():
	if sprite.animation == "Telegraph":
		launch_missiles()

func _on_Area2D_body_entered(body):
	if body is Player:
		on = true
		sprite.animation = "Telegraph"

func _on_Area2D2_area_entered(area):
	if (hp - 1) <= 0:
		die()
		return
		
	hp = hp - 1
	animation_player.play("Hurt")

func _on_IdleTimer_timeout():
	if on:
		sprite.animation = "Telegraph"

func _on_Area2D_body_exited(body):
	on = false
