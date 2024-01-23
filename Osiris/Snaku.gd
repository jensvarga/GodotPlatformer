extends Enemy

onready var sprite: = $AnimatedSprite
onready var attack_timer: = $AttackTimer
onready var hitbox_collider_right: = $Hitbox/CollisionShape2DRight
onready var hitbox_collider_left: = $Hitbox/CollisionShape2DLeft
onready var remove_timer := $RemoveTimer

var player
var player_position = Vector2.ZERO

export (int) var ATTACK_SPEED = 300
export (int) var DEATH_BOUNCE = -200
export (int) var bounce_strenght = 230

func _ready():
	state = IDLE
	hitbox_collider_right.set_deferred("disabled", true)
	hitbox_collider_left.set_deferred("disabled", true)

func _physics_process(delta):
	match state:
		IDLE:
			update_idle()
		AIM:
			update_aim()
		ATTACK:
			update_attack(delta)
		FROZEN:
			pass
		DEAD:
			update_dead(delta)

func enter_idle():
	sprite.rotation = 0
	state = IDLE
	sprite.animation = "Idle"
	
func enter_aim():
	sprite.rotation = 0
	state = AIM
	sprite.animation = "Aim"
	attack_timer.start()
	
func enter_attack():
	state = ATTACK
	sprite.animation = "Attack"
	if player != null:
		player_position = player.position
		direction = (player_position - position).normalized()
		if position.x < player_position.x:
			hitbox_collider_left.set_deferred("disabled", true)
			hitbox_collider_right.set_deferred("disabled", false)
			flip_sprite()
		else:
			hitbox_collider_left.set_deferred("disabled", false)
			hitbox_collider_right.set_deferred("disabled", true)
			
func exit_attack():
	hitbox_collider_left.set_deferred("disabled", true)
	hitbox_collider_right.set_deferred("disabled", true)

func enter_dead():
	AudioManager.play_random_hit_sound()
	state = DEAD
	disable_colliders()
	sprite.animation = "Dead"
	velocity.y = DEATH_BOUNCE
	
func update_attack(delta):
	if player_position == Vector2.ZERO:
		exit_attack()
		enter_idle()
		
	move_towards_target(delta)
	
	if is_on_wall():
		die()
	
func update_idle():
	pass
	
func update_aim():
	pass
	
func update_dead(delta):
	apply_gravity(delta)
	velocity = move_and_slide(velocity, Vector2.UP)
	remove_timer.start()
	
func apply_gravity(delta):
	velocity.y += gravity * delta
	velocity.y = min(velocity.y, 200)

func move_towards_target(delta):
	velocity = direction * ATTACK_SPEED
	position += velocity * delta
	var angle_offset = 0
	if not sprite.flip_h:
		angle_offset = PI
	var angle = direction.angle() + angle_offset
	sprite.rotation = lerp_angle(rotation, angle, 100 * delta)

func flip_sprite():
	sprite.flip_h = not sprite.flip_h

func disable_colliders():
	hitbox_collider_right.set_deferred("disabled", true)
	hitbox_collider_left.set_deferred("disabled", true)
	$CollisionShape2D.set_deferred("disabled", true)
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	
func lerp_angle(a, b, t):
	return (1.0 - t) * a + t * b
	
func die():
	enter_dead()

func _on_Area2D_body_entered(body):
	if state == ATTACK: return
	if body is Player:
		player = body
		enter_aim() 

func _on_Area2D_body_exited(body):
	if state == ATTACK: return
	if state == AIM and body is Player:
		player = body
		enter_idle()

func _on_AttackTimer_timeout():
	if state == AIM and player != null:
		enter_attack()

func _on_Hitbox_body_entered(body):
	if body is Player:
		state = FROZEN
		body.die()

func _on_Hurtbox_body_entered(body):
	if body is Player:
		body.bounce(bounce_strenght)
		die()


func _on_RemoveTimer_timeout():
	queue_free()
