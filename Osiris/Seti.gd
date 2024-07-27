extends KinematicBody2D

var player
enum { ENTER, IDLE, WALK, TELEGRAPH_PUNCH, PUNCH, JUMP, FALL, TELEGRAPH_JUMP, TELEPORT_OUT, TELEPORT_IN, TORNADO, DEAD }
var state = ENTER

onready var sprite := $AnimatedSprite
onready var animation_player := $AnimationPlayer
onready var burst_particles := $BurstPaticles

# Timers
onready var enter_timer := $EnterTimer
onready var idle_timer := $IdleTimer
onready var walk_timer := $WalkTimer
onready var telegraph_timer := $TelegraphTimer
onready var punch_timer := $PunchTimer
onready var invincible_timer := $InvincibleTimer
onready var teleport_timer := $TeleportTimer

# Detection
onready var player_detector := $PlayerDetector
onready var wall_detector := $WallDetector
onready var floor_detector := $FloorDetector

# Teleport positions
var t_center = Vector2(226, 103)
var teleport_locations = [
	Vector2(331, 103),
	Vector2(208, 103),
	Vector2(120, 103),
	Vector2(100, 103),
	t_center
]

# Colliders
onready var collision_shape := $CollisionShape2D

# Tornado colliders
onready var tf_center := $HitBox/CollisionCenter
onready var tf_colliders := [
	$HitBox/TF1,
	$HitBox/TF2,
	$HitBox/TF3,
	$HitBox/TF4,
	$HitBox/TF5,
	$HitBox/TF6,
	$HitBox/TF7,
	$HitBox/TF8,
	$HitBox/TF9,
	$HitBox/TF10,
	$HitBox/TF11,
	$HitBox/TF12,
	$HitBox/TF13
]

var move_speed = 50
var jump_height = 100
var velocity = Vector2.ZERO
var direction = Vector2(1, 0)
var start_position = Vector2.ZERO
var invincible = false

func _ready():
	Events.connect("boss_died", self, "_on_boss_died")
	tf_center.set_deferred("disabled", true)
	start_position = position
	enter_enter()
	if find_player_recursive(get_tree().root):
		player = find_player_recursive(get_tree().root)

func _physics_process(delta):
	if state != DEAD and Events.boss_hit_points <= 0:
		enter_dead()
	
	match state:
		ENTER:
			update_enter(delta)
		IDLE:
			update_idle(delta)
		WALK:
			update_walk(delta)
		TELEGRAPH_PUNCH:
			update_telegraph_punch(delta)
		PUNCH:
			update_punch(delta)
		JUMP:
			update_jump(delta)
		FALL:
			update_fall(delta)
		TELEPORT_OUT:
			pass
		TELEPORT_IN:
			update_teleport_in(delta)
		TORNADO:
			update_tornado(delta)
		DEAD:
			pass

# Enter states
func enter_enter():
	state = ENTER
	sprite.animation = "Enter"
	enter_timer.start()
	
func enter_idle():
	state = IDLE
	sprite.animation = "Idle"
	var random_time = rand_range(0.0, 2.0)
	idle_timer.wait_time = random_time
	idle_timer.start()
	face_player()
	
func enter_walk():
	state = WALK
	sprite.animation = "Walk"

func enter_telegraph_punch():
	state = TELEGRAPH_PUNCH
	sprite.animation = "TelegraphPunch"
	telegraph_timer.start()
	AudioManager.play_seti_telegraph()
	
func enter_telegraph_jump():
	state = TELEGRAPH_JUMP
	sprite.animation = "TelegraphJump"
	telegraph_timer.start()
	AudioManager.play_seti_tele_jump()

func enter_punch():
	state = PUNCH
	punch_timer.start()
	sprite.animation = "Punch"
	AudioManager.play_swoosh()
	
func enter_jump():
	state = JUMP
	sprite.animation = "Jump"
	
func enter_fall():
	state = FALL
	sprite.animation = "Fall"
	
func enter_teleport_out():
	state = TELEPORT_OUT
	teleport_timer.start()
	sprite.animation = "TeleportOut"
	burst_particles.emitting = true
	invincible = true
	AudioManager.play_teleport()
	collision_shape.set_deferred("disabled", true)

func enter_teleport_in():
	state = TELEPORT_IN
	self.position = find_closest_teleport() 
	sprite.animation = "TeleportIn"
	burst_particles.emitting = true
	AudioManager.play_teleport()
	collision_shape.set_deferred("disabled", false)
	
func enter_tornado():
	state = TORNADO
	self.position = t_center
	sprite.animation = "TeleportIn"
	invincible = true
	collision_shape.set_deferred("disabled", false)

func enter_dead():
	state = DEAD
	sprite.animation = "Die"
	collision_shape.set_deferred("disabled", true)
	AudioManager.fade_music()

# Update states
func update_enter(delta):
	pass
	
func update_idle(delta):
	if player_detector.is_colliding():
		transition_to_random_attack()
	
func update_walk(delta):
	if player_detector.is_colliding():
		transition_to_random_attack()
		
	if rand_range(0, 10000) > 9900:
		enter_telegraph_jump()
	
	face_player()
	velocity.x = direction.x * -move_speed
	velocity = move_and_slide(velocity, Vector2.UP)

	
func update_jump(delta):
	velocity.x = direction.x * -move_speed * 1.5
	velocity.y = -300
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if position.y < start_position.y - jump_height:
		enter_fall()

func update_fall(delta):
	velocity.x = direction.x * -move_speed * 1.5
	velocity.y = 300
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if floor_detector.is_colliding():
		CameraShaker.add_trauma(0.5)
		AudioManager.play_boom()
		enter_idle()
		
func update_teleport_in(delta):
	if sprite.frame == 6:
		invincible = false
		enter_idle()
		
func update_telegraph_punch(delta):
	pass

func update_punch(delta):
	velocity.x = direction.x * -300
	move_and_slide(velocity, Vector2.UP)
	
func update_tornado(delta):
	if sprite.animation == "TeleportIn" and sprite.frame == 6:
		invincible = false
		sprite.animation = "Tornado"
	
	if sprite.animation == "Tornado":
		activate_tf_colliders(sprite.frame)
		
	if sprite.frame == 16:
		enter_idle()

# Helpers
func transition_to_random_state():
	match int(rand_range(1, 6 + 1)):
		1, 2, 3:
			enter_walk()
		4, 5:
			enter_telegraph_jump()
		6:
			enter_teleport_out()
			
func transition_to_random_attack():
	match int(rand_range(1, 3 + 1)):
		1, 2:
			enter_telegraph_punch()
		3:
			enter_telegraph_jump()

func find_player_recursive(current_node):
	if current_node is Player:
		return current_node
	for child in current_node.get_children():
		var found_node = find_player_recursive(child)
		if found_node:
			return found_node
	return null
	
func face_player():
	var direction_to_player = (player.global_position - global_position).normalized()
	if direction_to_player.x * direction.x > 0:
		scale.x *= -1
		collision_shape.scale.x *= -1
		direction.x *= -1
	
func find_closest_teleport() -> Vector2:
	var closest_position: Vector2 = teleport_locations[0]
	var shortest_distance: float = player.position.distance_to(closest_position)
	
	for location in teleport_locations:
		var distance = player.position.distance_to(location)
		if distance < shortest_distance:
			shortest_distance = distance
			closest_position = location
	
	return closest_position

func activate_tf_colliders(frame: int):
	for i in range(tf_colliders.size()):
		if i == frame:
			tf_colliders[i].set_deferred("disabled", false)
		else:
			tf_colliders[i].set_deferred("disabled", true)
	
# Signals
func _on_EnterTimer_timeout():
	enter_idle()

func _on_IdleTimer_timeout():
	if state != IDLE:
		return
	transition_to_random_state()

func _on_WalkTimer_timeout():
	enter_idle()

func _on_TelegraphTimer_timeout():
	if state == TELEGRAPH_PUNCH:
		enter_punch()
	if state == TELEGRAPH_JUMP:
		enter_jump()

func _on_PunchTimer_timeout():
	enter_idle()

func _on_HurtBox_body_entered(body):
	if state == DEAD:
		return
	if (body is Player and velocity.y != 0) or (body is Player and invincible):
		body.bounce(400)
	elif body is Player and body.velocity.y > 0 and not invincible:
		if Events.boss_hit_points > 1:
			AudioManager.play_seti_hurt()
		Events.emit_signal("damage_boss")
		animation_player.play("Hurt")
		burst_particles.emitting = true
		body.bounce(400)
		invincible = true
		invincible_timer.start()

func _on_InvincibleTimer_timeout():
	invincible = false

func _on_boss_died():
	AudioManager.play_seti_die()

func _on_TeleportTimer_timeout():
	if Events.boss_hit_points <= 4:
		randomize()
		match int(rand_range(1, 2 + 1)):
			1:
				enter_teleport_in()
			2:
				enter_tornado()
	else:
		enter_teleport_in()
