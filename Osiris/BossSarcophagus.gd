extends StaticBody2D

var Seti = preload("res://Seti.tscn")

onready var sprite := $AnimatedSprite
onready var explode_timer := $ExplodeTimer

onready var part1 := $part1
onready var part2 := $part2
onready var part3 := $part3
onready var part4 := $part4
onready var part5 := $part5

var previous_frame = 0

func _ready():
	Events.boss_hit_points = 6
	sprite.animation = "default"
	part1.gravity_scale = 0
	part1.hide()
	part2.gravity_scale = 0
	part2.hide()
	part3.gravity_scale = 0
	part3.hide()
	part4.gravity_scale = 0
	part4.hide()
	part5.gravity_scale = 0
	part5.hide()
	start_crack()
	
func _process(delta):
	if previous_frame < sprite.frame:
		AudioManager.play_boom()
		
	previous_frame = sprite.frame
	
	
func start_crack():
	explode_timer.start()
	sprite.animation = "Explode"
	
func _on_ExplodeTimer_timeout():
	CameraShaker.add_trauma(0.6)
	AudioManager.play_set_entrance()
	AudioManager.play_boom()
	AudioManager.play_seti_music()
	var seti_instance = Seti.instance()
	seti_instance.position = position
	get_parent().add_child(seti_instance)
	
	sprite.hide()
	
	part1.show()
	part2.show()
	part3.show()
	part4.show()
	part5.show()
	
	part1.gravity_scale = 1
	part1.apply_central_impulse(Vector2(10, -150))
	part1.apply_torque_impulse(rand_range(-360, 360))
	
	part2.gravity_scale = 1
	part2.apply_central_impulse(Vector2(100, -50))
	part2.apply_torque_impulse(rand_range(-360, 360))
	
	part3.gravity_scale = 1
	part3.apply_central_impulse(Vector2(-100, -50))
	part3.apply_torque_impulse(rand_range(-360, 360))
	
	part4.gravity_scale = 1
	part4.apply_central_impulse(Vector2(100, -50))
	part4.apply_torque_impulse(rand_range(-360, 360))
	
	part5.gravity_scale = 1
	part5.apply_central_impulse(Vector2(-100, -50))
	part5.apply_torque_impulse(rand_range(-360, 360))
