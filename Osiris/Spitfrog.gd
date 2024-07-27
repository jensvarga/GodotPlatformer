extends StaticBody2D

onready var sprite := $AnimatedSprite
onready var tongue_sprite := $tongueSprite

onready var spit_timer := $SpitTimer
onready var tongue_timer := $TongueTimer

onready var hurt_area := $hurtArea

func _ready():
	tongue_sprite.animation = "Idle"
	sprite.animation = "Idle"
	spit_timer.start()
	
func _physics_process(delta):
	hurt_area.set_collision_mask_bit(1, tongue_sprite.frame == 3)
	
func spit():
	tongue_timer.start()
	sprite.animation = "Spit"

func _on_SpitTimer_timeout():
	spit()

func _on_AnimatedSprite_animation_finished():
	spit_timer.start()
	sprite.animation = "Idle"

func _on_TongueTimer_timeout():
	tongue_sprite.animation = "Spit"

func _on_tongueSprite_animation_finished():
	tongue_sprite.animation = "Idle"

func _on_hurtArea_body_entered(body):
	if body is Player:
		body.die()

func _on_DamageTimer_timeout():
	pass # Replace with function body.
