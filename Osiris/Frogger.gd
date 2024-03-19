extends StaticBody2D

onready var sprite := $AnimatedSprite
onready var attack_timer := $Timer
onready var particles := $CPUParticles2D

var slime_ball = preload("res://SlimeBall.tscn")

var attacking = false
var dead = false

func _ready():
	sprite.animation = "Idle"
	
func attack():
	attacking = true
	sprite.animation = "Attack"
	attack_timer.start()

func _on_DetectionArea_body_entered(body):
	if body is Turtle or body is Player:
		attack()

func _on_AnimatedSprite_animation_finished():
	if attacking:
		sprite.animation = "Idle"
		attacking = false
	if dead:
		queue_free()

func _on_HurtBox_body_entered(body):
	if body is Player  && !dead:
		dead = true
		sprite.animation = "Die"
		particles.emitting = true
		AudioManager.play_pop()
		body.bounce(350)

func _on_Timer_timeout():
	AudioManager.play_croak()
	var instance = slime_ball.instance()
	add_child(instance)
