extends StaticBody2D

class_name Stalagtite

export (bool) var lighthouse_hitbox = false

const DROP := preload("res://LavaDrop.tscn")

onready var drop_pos := $Position2D
onready var sprite := $AnimatedSprite
onready var timer := $Timer
onready var first_drop_timer := $FirstDropTimer
	
func _physics_process(delta):
	if sprite.frame == 6:
		drip()
		sprite.animation = "default"

func drip():
	AudioManager.play_lava_drip()
	var drop := DROP.instance()
	get_parent().call_deferred("add_child", drop)
	drop.position = drop_pos.global_position
	if lighthouse_hitbox:
		drop.call_deferred("lighthouse_hitbox")

func _on_Timer_timeout():
	sprite.animation = "Drip"
	timer.start()

func _on_VisibilityEnabler2D_screen_entered():
	if rand_range(-1, 1) > 0:
		sprite.animation = "Drip"
		
	var r = rand_range(-0.5, 0.5)
	first_drop_timer.wait_time = r
	timer.wait_time += r
	timer.start()

func _on_FirstDropTimer_timeout():
	sprite.animation = "Drip"
