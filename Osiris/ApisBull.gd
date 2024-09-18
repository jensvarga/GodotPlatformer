extends KinematicBody2D

const SPEED = 300
const PARTICLES = preload("res://BullParicles.tscn")

enum { IDLE, THRUST, ATTACK }
var state = IDLE
var velocity = Vector2.ZERO
export (int) var direction = -1
var hp: int = 15
var first = true # To avoid explosion on ready

onready var sprite := $AnimatedSprite
onready var thrust_timer := $ThrustTimer
onready var idle_timer := $IdleTimer
onready var attack_timer := $AttackTimer

func _ready():
	pass
	
func _physics_process(delta):
	match state:
		IDLE:
			update_idle()
		THRUST:
			update_thrust()
		ATTACK:
			update_attack()
	
func enter_idle():
	state = IDLE
	sprite.animation = "Idle"
	idle_timer.wait_time = rand_range(0.5, 3.0)
	idle_timer.start()

func enter_thrust():
	state = THRUST
	sprite.animation = "Thrust"
	thrust_timer.start()
	AudioManager.play_cow_thrust()
	
func enter_attack():
	AudioManager.play_cow_attck()
	state = ATTACK
	sprite.animation = "Run"
	attack_timer.start()
	
func update_idle():
	pass

func update_thrust():
	pass

func update_attack():
	velocity.x = direction * SPEED
	velocity = move_and_slide(velocity, Vector2.UP)

func hurt():
	if hp - 1 <= 0:
		die()
	else:
		AudioManager.play_random_hit_sound()
		AudioManager.play_cow_moo()
		$AnimationPlayer.play("Hurt")
		hp -= 1

func on_shot():
	hurt()

func die():
	Events.emit_signal("killed_miniboss")
	AudioManager.play_random_fart()
	AudioManager.play_cow_die()
	var parts = PARTICLES.instance()
	get_tree().root.get_child(4).call_deferred("add_child", parts)
	parts.position = global_position
	queue_free()

func _on_ThrustTimer_timeout():
	enter_attack()

func _on_IdleTimer_timeout():
	enter_thrust()

func _on_AttackTimer_timeout():
	direction *= -1
	scale.x *= -1
	enter_idle()

func _on_Hitbox_body_entered(body):
	if first:
		first = false
		return
	if body is Player:
		body.hurt()
		
	CameraShaker.add_trauma(.6)
	AudioManager.play_random_explosion_sound()

func _on_VisibilityEnabler2D_screen_entered():
	enter_idle()
