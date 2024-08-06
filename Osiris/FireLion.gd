extends StaticBody2D

onready var sprite := $AnimatedSprite
onready var fire_timer := $FireTimer
onready var particles := $CPUParticles2D
onready var fire_collider := $HurtArea/CollisionPolygon2D
onready var death_timer := $DeathTimer

enum { IDLE, FIRE, DEAD, FROZEN }

var state = FROZEN

func _ready():
	pass

func _physics_process(delta):
	match state:
		IDLE:
			update_idle(delta)
		FIRE:
			update_fire(delta)
		DEAD:
			pass
		FROZEN:
			pass

func enter_idle():
	state = IDLE
	sprite.animation = "Idle"
	particles.emitting = false
	fire_timer.start()
	fire_collider.set_deferred("disabled", true)
	
func enter_fire():
	state = FIRE
	sprite.animation = "Fire"
	particles.emitting = true
	AudioManager.play_leo_fire()
	fire_timer.start()
	$ColliderDelayTimer.start()

func update_idle(delta):
	pass

func update_fire(delta):
	pass
	
func die():
	state = DEAD
	sprite.animation = "Die"
	particles.emitting = false
	death_timer.start()

func _on_FireTimer_timeout():
	match state:
		IDLE:
			enter_fire()
		FIRE:
			enter_idle()
		DEAD:
			pass
		FROZEN:
			pass

func _on_VisibilityEnabler2D_screen_entered():
	enter_idle()

func _on_VisibilityEnabler2D_screen_exited():
	state = FROZEN

func _on_DeathTimer_timeout():
	queue_free()

func _on_ColliderDelayTimer_timeout():
	if state == FIRE:
		fire_collider.set_deferred("disabled", false)
		
func _on_HurtArea_body_entered(body):
	if body is Player and state == FIRE:
		body.hurt()

func _on_Hitbox_body_entered(body):
	if body is Player and body.velocity.y > 0:
		body.bounce(400)
		die()

func _on_Hitbox_body_exited(body):
	pass
