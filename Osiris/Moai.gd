extends StaticBody2D

class_name Moai

const BOULDER := preload("res://MoaiBoulder.tscn")

onready var sprite := $AnimatedSprite
onready var rock_pos := $Position2D
onready var attack_timer := $AttackTimer

var attacked = false

func _ready():
	sprite.animation = "Idle"
	attack_timer.wait_time += rand_range(-2, 2)
	attack_timer.start()

func _physics_process(delta):
	if sprite.frame == 4 and not attacked:
		summon_boulder()
		attacked = true
	if sprite.frame == 7:
		attacked = false
		sprite.animation = "Idle"
		attack_timer.start()

func summon_boulder():
	var boulder := BOULDER.instance()
	get_parent().call_deferred("add_child", boulder)
	boulder.position = rock_pos.global_position
	boulder.call_deferred("apply_central_impulse", Vector2(50 * scale.x, 0))


func _on_AttackTimer_timeout():
	sprite.animation = "Attack"
