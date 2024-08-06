extends RigidBody2D

onready var particles := $CPUParticles2D
onready var particles2 := $CPUParticles2D2

var disabled = false

func _ready():
	angular_velocity = rand_range(0, 10)
	
func disable():
	disabled = true
	$Sprite.hide()
	$DestroyTimer.start()

func _on_Area2D_body_entered(body):
	if disabled:
		return
	
	if body is Player:
		body.hurt()
		
	AudioManager.play_random_fart()
	particles.restart()
	particles2.restart()
	
	disable()

func _on_DestroyTimer_timeout():
	queue_free()
