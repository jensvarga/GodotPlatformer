extends Node2D

const FIRE := preload("res://FallingFire.tscn")

onready var fire_rain_timer := $"../FireRainTimer"
onready var earthquake_timer := $"../EarthQuakeTimer"
onready var animation_player := $"../AnimationPlayer"

func _ready():
	Events.connect("boss_died", self, "_on_boss_died")
	Events.boss_hit_points = 12
	Events.has_power_crook = true
	Events.has_talaria = true
	
func _on_boss_died():
	AudioManager.play_fanfare()
	animation_player.play("LowerFoot")
	fire_rain_timer.start()
	earthquake_timer.start()

func _on_FireRainTimer_timeout():
	var rand = rand_range(-1, 1)
	if rand < 0:
		fire_rain_timer.wait_time = 3.5
		fire_rain_timer.start()
	else:
		fire_rain_timer.wait_time = 2.2
		fire_rain_timer.start()
	
	var fire = FIRE.instance()
	fire.position = Vector2(rand_range(-200, 200), -175)
	add_child(fire)

func _on_EarthQuakeTimer_timeout():
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
