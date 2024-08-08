extends StaticBody2D

onready var telegraph_particles := $TelegraphParticles
onready var fire_particles := $FireParticles
onready var telegraph_timer := $TelegraphTimer
onready var fire_timer := $FireTimer
onready var fire_collider := $Hurtbox/CollisionShape2D

func _ready():
	fire_collider.set_deferred("disabled", true)

func _on_TelegraphTimer_timeout():
	fire_timer.start()
	fire_particles.emitting = true
	fire_collider.set_deferred("disabled", false)
	AudioManager.play_flame()
	
func _on_FireTimer_timeout():
	fire_particles.emitting = false
	fire_collider.set_deferred("disabled", true)

func _on_PlayerDetection_body_entered(body):
	telegraph_particles.restart()
	telegraph_timer.start()
	AudioManager.play_click()

func _on_Hurtbox_body_entered(body):
	if body is Player:
		body.hurt()
		return
	if body is Crook:
		body.enter_death()
		return
	if body is Enemy:
		body.die()
		return
