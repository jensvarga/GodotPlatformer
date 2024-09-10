extends Node2D

class_name HorEmAkhet

const FIREBALL = preload("res://SphinxFireball.tscn")

var hp = 3

signal on
signal off
signal hurt

onready var animation_player := $AnimationPlayer
onready var paw_animation_player := $PawAnimationPlayer
onready var trauma_timer := $TraumaTimer
onready var head_sprite := $Path2D/PathFollow2D/Head
onready var fire_pos := $Path2D/PathFollow2D/Head/FirePosition
onready var scream_timer := $ScreamTimer
onready var toggle_timer = Timer.new()
onready var sprite := $Path2D/PathFollow2D/Body

var shader_material: Material = null

var toggle_count = 0

var fired = false
var first = true
var root_node: Node = null

func _ready():
	connect("on", self, "_on_on")
	connect("off", self, "_on_off")
	connect("hurt", self, "_on_hurt")
	toggle_timer.wait_time = 0.1
	toggle_timer.connect("timeout", self, "_on_toggle_timer_timeout")
	add_child(toggle_timer)
	head_sprite.animation = "default"
	root_node = get_tree().root.get_child(0)
	shader_material = sprite.material

func _physics_process(delta):
	if head_sprite.frame == 4 and not fired:
		fired = true
		AudioManager.play_random_explosion_sound()
		var base_direction = Events.player.global_position - fire_pos.global_position
		base_direction = base_direction.normalized()

		var angle_offset = deg2rad(5)

		var fireball_center := FIREBALL.instance()
		root_node.add_child(fireball_center)
		fireball_center.position = fire_pos.global_position
		fireball_center.set_direction(base_direction)

		var fireball_above := FIREBALL.instance()
		root_node.add_child(fireball_above)
		fireball_above.position = fire_pos.global_position
		fireball_above.set_direction(rotate_vector(base_direction, -angle_offset))

		var fireball_below := FIREBALL.instance()
		root_node.add_child(fireball_below)
		fireball_below.position = fire_pos.global_position
		fireball_below.set_direction(rotate_vector(base_direction, angle_offset))
		
	if head_sprite.frame != 4:
		fired = false

func rotate_vector(vec, angle):
	return Vector2(vec.x * cos(angle) - vec.y * sin(angle),
				   vec.x * sin(angle) + vec.y * cos(angle))
	
func _on_Area2D_body_entered(body):
	if body is Player:
		body.hurt()
	
func _on_on():
	if not first:
		head_sprite.animation = "Attack"
	first = false
	animation_player.play("MoveBody")
	paw_animation_player.play("MovePaws")
	trauma_timer.start()
	scream_timer.wait_time = rand_range(3, 10)
	scream_timer.start()

func _on_off():
	head_sprite.animation = "default"
	animation_player.stop()
	paw_animation_player.stop()
	trauma_timer.stop()

func _on_TraumaTimer_timeout():
	trauma_timer.start()
	AudioManager.play_boom()
	CameraShaker.add_trauma(0.4)

func _on_ScreamTimer_timeout():
	AudioManager.play_hor_em_scream()
	scream_timer.wait_time = rand_range(3, 10)
	scream_timer.start()

func _on_DeathArea_body_entered(body):
	if body is Player:
		body.die()

func _on_toggle_timer_timeout():
	shader_material.set_shader_param("active", !shader_material.get_shader_param("active"))
	toggle_count += 1
	if toggle_count >= 6:
		toggle_timer.stop()

func toggle_shader_param():
	toggle_count = 0
	toggle_timer.start()

func die():
	Events.emit_signal("boss_died")
	scream_timer.stop()
	emit_signal("off")

func _on_hurt():
	if (hp - 1) <= 0:
		die()
	else:
		toggle_shader_param()
		AudioManager.play_hor_em_scream()
		hp -= 1
		
