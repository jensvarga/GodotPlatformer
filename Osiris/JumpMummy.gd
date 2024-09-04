extends RigidBody2D

onready var part_1 := $CPUParticles2D
onready var part_2 := $CPUParticles2D2

var boomed = false

func _ready():
	pass

func explode():
	part_1.restart()
	part_2.restart()
	$AnimatedSprite.hide()
	$CollisionShape2D.set_deferred("disabled", true)
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	$Area2D/CollisionShape2D2.set_deferred("disabled", false)
	$DestroyTimer.start()
	if not boomed:
		CameraShaker.add_trauma(0.6)
		AudioManager.play_boom()
		boomed = true

func _on_Area2D_body_entered(body):
	if body == self:
		return
	if body is Player:
		body.hurt()
	if body.has_method("on_shot"):
		body.on_shot()
		
	explode()

func _on_DestroyTimer_timeout():
	queue_free()
