extends KinematicBody2D

onready var start_fall_timer := $StartFallTimer
onready var disable_collider_timer := $DisableColliderTimer
onready var collider := $CollisionShape2D
onready var sprite := $AnimatedSprite

func _ready():
	sprite.animation = "Idle"
	
func reset():
	sprite.animation = "Idle"
	collider.set_deferred("disabled", false)

func fall():
	sprite.animation = "Fall"

func _on_Area2D_body_entered(body):
	start_fall_timer.start()
	disable_collider_timer.start()

func _on_StartFallTimer_timeout():
	fall()

func _on_AnimatedSprite_animation_finished():
	reset()

func _on_DisableColliderTimer_timeout():
	collider.set_deferred("disabled", true)
