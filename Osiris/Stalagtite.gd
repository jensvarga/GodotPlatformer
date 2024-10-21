extends StaticBody2D

class_name Stalagtite

const DROP := preload("res://LavaDrop.tscn")

onready var drop_pos := $Position2D
onready var sprite := $AnimatedSprite

func _ready():
	var r = rand_range(-0.5, 0.5)
	$Timer.wait_time += r
	
func _physics_process(delta):
	if sprite.frame == 6:
		drip()
		sprite.animation = "default"

func drip():
	AudioManager.play_lava_drip()
	var drop := DROP.instance()
	get_parent().call_deferred("add_child", drop)
	drop.position = drop_pos.global_position

func _on_Timer_timeout():
	sprite.animation = "Drip"
