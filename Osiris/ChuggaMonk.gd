extends Node2D

onready var sprite := $AnimatedSprite
onready var timer := $Timer
var poop = preload("res://Poop.tscn")

enum { IDLE, THROWING, DEAD }
var state = THROWING

var thrown = false

func _ready():
	enter_idle()
	timer.start()
	
func _physics_process(delta):
	match state:
		IDLE:
			update_idle(delta)
		THROWING:
			update_throwing(delta)
		DEAD:
			pass

func enter_idle():
	state = IDLE
	sprite.animation = "Idle"
	
func enter_throwing():
	state = THROWING
	sprite.animation = "Throw"
	timer.start()

func update_idle(delta):
	pass
	
func update_throwing(delta):
	#if sprite.frame == 2:
	if sprite.frame == 2 and not thrown:
		throw_poop()
		thrown = true
	if sprite.frame == 3:
		thrown = false
		enter_idle()
		
func throw_poop():
	var poop_instance = poop.instance()
	get_parent().call_deferred("add_child", poop_instance)
	poop_instance.position = position
	poop_instance.apply_central_impulse(Vector2(-50 * scale.x, -50))
	AudioManager.play_random_fart()

func die():
	sprite.animation = "Die"
	state = DEAD
	$DeadTimer.start()
	
func _on_Area2D_body_entered(body):
	if body is Player and body.velocity.y > 0:
		body.bounce(400)
		die()

func _on_Timer_timeout():
	if state == DEAD:
		return
	enter_throwing()

func _on_DeadTimer_timeout():
	queue_free()
