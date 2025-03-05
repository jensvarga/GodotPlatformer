extends StaticBody2D

export (int) var bullets = -1

const BULLET := preload("res://BullyBullet.tscn")

export (float) var delay = 0.05

onready var fire_timer := $FireTimer
onready var fire_pos := $Position2D
onready var delay_timer := $DelayTimer

func _ready():
	delay_timer.wait_time = delay

func _on_FireTimer_timeout():
	if bullets != 0:
		fire()

func _on_VisibilityNotifier2D_screen_entered():
	delay_timer.start()

func _on_VisibilityNotifier2D_screen_exited():
	fire_timer.stop()

func _on_DelayTimer_timeout():
	fire()
	fire_timer.start()
	
func fire():
	bullets -= 1
	AudioManager.play_boom()
	var bullet := BULLET.instance()
	bullet.position = fire_pos.global_position
	bullet.call_deferred("set_direction", Vector2(scale.x, 0))
	get_parent().call_deferred("add_child", bullet)
