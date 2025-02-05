extends KinematicBody2D

class_name Camel

const SPLAT := preload("res://BirdSplat.tscn")
const SOUND = preload("res://Sound/FX/MISC/camel_moan.wav")

const GRAVITY := 540
const MOVE_SPEED := 25

onready var sprite := $AnimatedSprite
onready var ray := $RaycastNode/RayCast2D
onready var ray_node := $RaycastNode

var velocity = Vector2.ZERO
var direction = -1
var stopped := false

func _physics_process(delta):
	var found_wall = is_on_wall()
	velocity.y += GRAVITY * delta
	
	if found_wall or (not ray.is_colliding()):
		direction *= -1
		flip_sprite()
		
	if stopped:
		velocity.x = 0
	else:
		velocity.x = direction * MOVE_SPEED
		
	velocity = move_and_slide(velocity, Vector2.UP)

func flip_sprite():
	sprite.flip_h = not sprite.flip_h
	ray_node.scale.x *= -1

func on_shot():
	die()

func die():
	var splat := SPLAT.instance()
	get_parent().call_deferred("add_child", splat)
	splat.position = global_position
	call_deferred("queue_free")
	
func _on_Area2D_body_entered(body):
	if body is Player:
		AudioManager.play_sound(SOUND)
		stopped = true
		sprite.animation = "Bounce"
		body.bounce(800)

func _on_AnimatedSprite_animation_finished():
	if sprite.animation == "Bounce":
		AudioManager.play_boom()
		stopped = false
		die()
