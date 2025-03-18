extends Node2D

const FIRE_BALL := preload("res://SwirlingFireball.tscn")
const FIRE_SOUND := preload("res://Sound/FX/MISC/apep_firebreath.wav")

onready var fire_pos := $Position2D

signal spit

func _ready():
	connect("spit", self, "_on_spit")

func _on_spit():
	AudioManager.play_aphopis_bite_sound()
	AudioManager.play_sound(FIRE_SOUND)
	
	var throws = int(rand_range(50, 100))
	
	for i in range(throws):
		var fire_ball := FIRE_BALL.instance()
		get_parent().call_deferred("add_child", fire_ball)

		fire_ball.position = fire_pos.global_position
		
		var angle = deg2rad(rand_range(-100, -60))
		if scale.x < 0:
			angle = deg2rad(rand_range(100, 180))
		
		var speed = rand_range(250, 400)  

		fire_ball.set_deferred("linear_velocity", Vector2(cos(angle), sin(angle)) * speed)

		yield(get_tree().create_timer(rand_range(0.03, 0.1)), "timeout")

