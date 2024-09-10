extends KinematicBody2D

const FIREBALL = preload("res://SphinxFireball.tscn")

onready var sprite := $Sprite
onready var fire_timer := $FireTimer
onready var fire_pos := $FirePosition

export (bool) var go = false
var fired = false

func _ready():
	sprite.animation = "default"

func _physics_process(delta):
	if go:
		start_sequence()
		go = false
	
	if sprite.frame == 4 and not fired:
		fired = true
		AudioManager.play_random_explosion_sound()
		var base_direction = Events.player.global_position - fire_pos.global_position
		base_direction = base_direction.normalized()

		var angle_offset = deg2rad(5)

		var fireball_center := FIREBALL.instance()
		get_parent().add_child(fireball_center)
		fireball_center.position = fire_pos.global_position
		fireball_center.set_direction(base_direction)

		var fireball_above := FIREBALL.instance()
		get_parent().add_child(fireball_above)
		fireball_above.position = fire_pos.global_position
		fireball_above.set_direction(rotate_vector(base_direction, -angle_offset))

		var fireball_below := FIREBALL.instance()
		get_parent().add_child(fireball_below)
		fireball_below.position = fire_pos.global_position
		fireball_below.set_direction(rotate_vector(base_direction, angle_offset))
		
	if sprite.frame != 4:
		fired = false

func rotate_vector(vec, angle):
	return Vector2(vec.x * cos(angle) - vec.y * sin(angle),
				   vec.x * sin(angle) + vec.y * cos(angle))

func start_sequence():
	AudioManager.play_hor_em_scream()
	CameraShaker.add_trauma(0.6)
	$AwakenTimer.start()


func _on_AwakenTimer_timeout():
	sprite.animation = "Awaken"
	sprite.frame = 0
	sprite.play()
	$Timer.start()

func _on_FireTimer_timeout():
	fire_timer.start()
	sprite.animation = "Fire"
	sprite.frame = 0


func _on_Timer_timeout():
	fire_timer.start()
