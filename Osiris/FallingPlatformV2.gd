extends KinematicBody2D

class_name FallingPlatform

onready var body_collider := $CollisionShape2D
onready var area_collider := $Area2D/CollisionShape2D
onready var in_ari_collider := $InAirArea/CollisionShape2D

const GRAVITY = 540
var velocity := Vector2.ZERO
var apply_gravity = false

func _ready():
	body_collider.set_deferred("disabled", true)
	in_ari_collider.set_deferred("disabled", true)

func _physics_process(delta):
	if apply_gravity:
		velocity.y += GRAVITY * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
func _on_Area2D_body_entered(body):
	if body is Player and not apply_gravity:
		AudioManager.play_click()
		apply_gravity = true
		area_collider.set_deferred("disabled", true)
		set_collision_mask_bit(2, false)  
		yield(get_tree().create_timer(0.3), "timeout")
		set_collision_mask_bit(2, true)
		body_collider.set_deferred("disabled", false)
		in_ari_collider.set_deferred("disabled", false)

func _on_InAirArea_body_entered(body):
	in_ari_collider.set_deferred("disabled", true)
	body_collider.set_deferred("disabled", false)
