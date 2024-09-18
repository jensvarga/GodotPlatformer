extends StaticBody2D

const EXPLOSION1 = preload("res://Explosion1.tscn")

onready var positions = [
	$Position2D, 
	$Position2D2, 
	$Position2D3, 
	$Position2D4, 
	$Position2D5, 
	$Position2D6, 
	$Position2D7,
	$Position2D8
]
	
var explosion_timer = Timer.new()
var explosion_duration = 2.0
var explosion_interval = 0.1
var elapsed_time = 0.0

func _ready():
	explosion_timer.set_wait_time(explosion_interval)
	explosion_timer.connect("timeout", self, "_on_explosion_timer_timeout")
	add_child(explosion_timer)
	start_explosions()

func start_explosions():
	elapsed_time = 0.0
	explosion_timer.start()

func _on_explosion_timer_timeout():
	elapsed_time += explosion_interval
	
	spawn_random_explosion()

	if elapsed_time >= explosion_duration:
		explosion_timer.stop()

func spawn_random_explosion():
	AudioManager.play_random_explosion_sound()
	var random_position = positions[int(rand_range(0, positions.size()))]
	var explosion = EXPLOSION1.instance()
	get_parent().call_deferred("add_child", explosion)
	explosion.position = random_position.global_position

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		queue_free()
