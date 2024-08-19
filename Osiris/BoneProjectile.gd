extends RigidBody2D

var disabled = false

func _ready():
	angular_velocity = rand_range(0, 10)
	
func disable():
	angular_velocity = 0
	disabled = true
	$Sprite.hide()
	$DestroyTimer.start()
	$CPUParticles2D.restart()

func _on_Area2D_body_entered(body):
	if disabled or body == self:
		return
	
	if body is Player:
		body.hurt()
		
	disable()

func _on_DestroyTimer_timeout():
	queue_free()
