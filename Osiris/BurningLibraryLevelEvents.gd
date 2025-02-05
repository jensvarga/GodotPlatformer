extends Node2D

const FIRE := preload("res://FallingFire.tscn")

onready var fire_rain_timer := $FireRainTimer
onready var earthquake_timer := $EartquakeTimer

func _ready():
	Events.has_power_crook = true
	Events.has_talaria = true
	fire_rain_timer.start()
	earthquake_timer.start()

func _on_FireRainTimer_timeout():
	var rand = rand_range(-1, 1)
	if rand < 0:
		fire_rain_timer.wait_time = 1.5
		fire_rain_timer.start()
	else:
		fire_rain_timer.wait_time = 1
		fire_rain_timer.start()
	
	var fire = FIRE.instance()
	var x_pos = Events.player.global_position.x
	fire.position = Vector2(rand_range(x_pos - 100, x_pos + 100), -175)
	add_child(fire)

func _on_EartquakeTimer_timeout():
	var rand = rand_range(-1, 1)
	if rand < 0:
		AudioManager.play_low_rumble()
		earthquake_timer.wait_time = 4.1
		earthquake_timer.start()
	else:
		AudioManager.play_boom()
		earthquake_timer.wait_time = 2.4
		earthquake_timer.start()
		
	CameraShaker.call_deferred("add_trauma", 0.5)

func _on_WinArea_body_entered(body):
	if body is Player:
		Events.emit_signal("stage_cleared")
		Events.library_burned = true
		Events.has_left_foot = true
		AudioManager.play_random_checkpoint_sound()
