extends KinematicBody2D

class_name ParoBoulder

const PARTICLES = preload("res://BennyFireballParticles.tscn")

const SPEED = 100
const GRAVITY = 540
const BOUNCE = -20000

onready var sprite := $Sprite

var velocity = Vector2.ZERO
var direction = -1
var live = false

func _ready():
	Events.connect("boss_died", self, "_on_boss_died")
	velocity.x = SPEED * direction
	
func _physics_process(delta):
	velocity.y += GRAVITY * delta
	
	sprite.rotation += delta * 5
	
	if is_on_wall():
		call_deferred("queue_free")
	
	if is_on_floor():
		velocity.y = BOUNCE * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)

func spawn_particles():
	var particles = PARTICLES.instance()
	particles.position = global_position
	get_parent().call_deferred("add_child", particles)

func _on_Area2D_body_entered(body):
	if live:
		if body is Player:
			body.hurt()
			spawn_particles()
			call_deferred("queue_free")
			
		if body.name == "Paro":
			spawn_particles()
			call_deferred("queue_free")

func _on_Timer_timeout():
	live = true

func _on_boss_died():
	spawn_particles()
	call_deferred("queue_free")
