extends KinematicBody2D

const IDLE_SPEED = 50
const ATTACK_SPEED = 300
const PROJECTILE = preload("res://BennuFireball.tscn")
var speed = IDLE_SPEED

onready var wings_sprite := $WingsSprite
onready var body_sprite := $BodySprite
onready var tween := $Tween
onready var animation_player := $AnimationPlayer
onready var hex_particles := $CPUParticles2D
onready var fire_position := $FirePosition

# Timers
onready var enter_timer := $EnterTimer
onready var idle_timer := $IdleTimer
onready var telegraph_shoot_timer := $TelegraphShootTimer

var start_position = Vector2.ZERO
var target_position = Vector2.ZERO
var idle_positions = [
	Vector2(148, -32),
	Vector2(-168, -32)
]
var swoop_pattern
var current_target_index = 0
var swoop_patterns = [
	[
		Vector2(205, 100),  # Right corner
		Vector2(-193, 100), # Left corner
		Vector2(10, -75)
	],
	[
		Vector2(205, 100),  # Right corner
		Vector2(-193, 100), # Left corner
		Vector2(-193, 70),
		Vector2(205, 70),
		Vector2(10, -75)
	],
	[
		Vector2(-193, 100), # Left corner
		Vector2(205, 100),  # Right corner
		Vector2(10, -75)
	],
	[
		Vector2(-193, 100), # Left corner
		Vector2(205, 100),  # Right corner
		Vector2(205, 70),
		Vector2(-193, 70),
		Vector2(10, -75)
	],
	[
		Vector2(72, 100), # Zig-zag from right
		Vector2(10, -75),
		Vector2(-145, 100)
	],
	[
		Vector2(-145, 100), # Zig-zag from left
		Vector2(10, -75),
		Vector2(72, 100)
	]
]
const CENTER_POSITION = Vector2(-7, -77)
var shots_to_fire = 0
var fired = false

enum { ENTER, IDLE, SWOOP, SETUP_SHOOT, SHOOT, TELEGRAPH_SHOOT, DIE, DEAD }
var state
var invincible = true
var velocity = Vector2.ZERO
var direction: Vector2

func _ready():
	wings_sprite.material.set("shader_param/active_bob", false)
	start_position = position
	wings_sprite.animation = "default"
	body_sprite.animation = "default"
	enter_timer.start()
	Events.connect("damage_boss", self, "_on_damage_boss")
	Events.connect("boss_died", self, "_on_boss_died")
	body_sprite.material.set("shader_param/sensitivity", 0)

func _physics_process(delta):
	match state:
		ENTER:
			pass
		IDLE:
			update_idle(delta)
		SWOOP:
			update_swoop()
		SETUP_SHOOT:
			update_setup_shoot()
		SHOOT:
			update_shoot()
		TELEGRAPH_SHOOT:
			pass
		DIE:
			update_die()
		DEAD:
			pass

func enter_enter():
	state = ENTER
	enter_timer.start()
	wings_sprite.animation = "Enter"
	body_sprite.animation = "Enter"
	AudioManager.play_bennu_wake_up()

func exit_enter():
	AudioManager.play_bennu_music()
	target_position.x = start_position.x + rand_range(-20, 20)
	target_position.y = start_position.y - 150
	wings_sprite.material.set("shader_param/active_bob", true)

func enter_idle():
	state = IDLE
	wings_sprite.animation = "Idle"
	body_sprite.animation = "Idle"
	idle_timer.wait_time = rand_range(1, 3)
	if Events.boss_hit_points <= 4:
		idle_timer.wait_time = rand_range(0, 2)
	target_position = idle_positions[int(rand_range(0, idle_positions.size()))]

func enter_swoop():
	state = SWOOP
	wings_sprite.animation = "default"
	body_sprite.animation = "Swoop"
	swoop_pattern = swoop_patterns[int(rand_range(0, swoop_patterns.size()))]
	AudioManager.play_bennu_attack()
	
func enter_telegraph_shoot():
	state = TELEGRAPH_SHOOT
	AudioManager.play_electric_charge()
	body_sprite.animation = "Hex"
	hex_particles.emitting = true
	telegraph_shoot_timer.start()
	fired = false

func enter_shoot():
	state = SHOOT
	body_sprite.animation = "Shoot"
	hex_particles.emitting = false

func enter_setup_shoot():
	state = SETUP_SHOOT
	wings_sprite.animation = "Idle"
	body_sprite.animation = "Idle"
	var fire_positions = idle_positions.duplicate()
	fire_positions.append(CENTER_POSITION)
	target_position = fire_positions[int(rand_range(0, fire_positions.size()))]
	shots_to_fire = int(rand_range(2, 6))

func enter_die():
	state = DIE
	body_sprite.animation  = "Die"
	wings_sprite.animation = "default"
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	idle_timer.stop()
	telegraph_shoot_timer.stop()
	velocity.x = 0
	AudioManager.fade_music()
	AudioManager.play_bennu_attack()

func enter_dead():
	state = DEAD
	animation_player.play("Disolve")
	$KillTimer.start()

func update_die():
	velocity.y = -1 * IDLE_SPEED / 2
	velocity = move_and_slide(velocity, Vector2.UP)
	if body_sprite.frame == 3:
		enter_dead()
	
	
func update_idle(delta):		
	var distance := global_transform.origin.distance_to(target_position)
	if distance > 10:
		direction = global_transform.origin.direction_to(target_position)
		velocity.x = direction.x * speed
		velocity.y = direction.y * speed
		velocity = move_and_slide(velocity, Vector2.UP)
	elif idle_timer.time_left <= 0:
		idle_timer.start()
	
	face_direction()
		
func update_swoop():
	if current_target_index >= swoop_pattern.size():
		if Events.boss_hit_points < 4:
			AudioManager.play_bennu_shoot()
			var num_projectiles = int(rand_range(7, 15))
			var angle_increment = PI / num_projectiles

			for i in range(num_projectiles):
				var projectile = PROJECTILE.instance()
				var angle = i * angle_increment
				var direction = Vector2(cos(angle), sin(angle))
				
				projectile.position = fire_position.global_position
				var angular_velocity = rand_range(-1, 1)
				projectile.set_direction(direction, angle, angular_velocity)
				get_parent().call_deferred("add_child", projectile)
		reset_swoop()
		enter_idle()
		return
	
	var target_position = swoop_pattern[current_target_index]
	var distance = global_transform.origin.distance_to(target_position)
	
	if distance > 10:
		direction = global_transform.origin.direction_to(target_position)
		velocity.x = direction.x * (ATTACK_SPEED + rand_range(0, 100))
		velocity.y = direction.y * (ATTACK_SPEED + rand_range(0, 100))
		velocity = move_and_slide(velocity, Vector2.UP)
	else:
		current_target_index += 1
	
	face_direction()
	
func update_shoot():
	if body_sprite.frame == 0 and not fired:
		AudioManager.play_bennu_shoot()
		fired = true
		var num_projectiles = int(rand_range(7, 15))
		var angle_increment = PI / num_projectiles

		for i in range(num_projectiles):
			var projectile = PROJECTILE.instance()
			var angle = i * angle_increment
			var direction = Vector2(cos(angle), sin(angle))
			
			projectile.position = fire_position.global_position
			var angular_velocity = rand_range(-1, 1)
			projectile.set_direction(direction, angle, angular_velocity)
		
			get_parent().call_deferred("add_child", projectile)
	else:
		shots_to_fire -= 1
		if shots_to_fire > 0:
			enter_telegraph_shoot()
		else:
			fired = false
			enter_idle()

func update_setup_shoot():
	var distance := global_transform.origin.distance_to(target_position)
	if distance > 10:
		direction = global_transform.origin.direction_to(target_position)
		velocity.x = direction.x * speed
		velocity.y = direction.y * speed
		velocity = move_and_slide(velocity, Vector2.UP)
	else:
		enter_telegraph_shoot()
	
	face_direction()
	
func reset_swoop():
	current_target_index = 0

func face_direction():
	if velocity.x > 0:
		body_sprite.scale.x = -1
		wings_sprite.scale.x = -1
	elif velocity.x < 0:
		body_sprite.scale.x = 1
		wings_sprite.scale.x = 1
		
func hurt():
	Events.emit_signal("damage_boss")
	animation_player.play("Hurt")
	AudioManager.play_random_hit_sound()
	AudioManager.play_bennu_hurt()

func on_shot():
	if not invincible:
		hurt()

func _on_damage_boss():
	if Events.boss_hit_points < 6:
		speed = IDLE_SPEED * 1.5
	if Events.boss_hit_points < 3:
		speed = IDLE_SPEED * 2
	
func random_attack():
	var random = int(rand_range(1, 2 + 1))
	
	if Events.boss_hit_points < 10:
		random = int(rand_range(1, 3 + 1))
		
	match random:
		1, 2:
			enter_swoop()
		3:
			enter_setup_shoot()

func _on_boss_died():
	if state != DIE:
		enter_die()

func _on_EnterTimer_timeout():
	if state == ENTER:
		invincible = false
		enter_idle()
		exit_enter()
	else:
		enter_enter()

func _on_IdleTimer_timeout():
	random_attack()

func _on_Area2D_body_entered(body):
	if body is Player:
		body.hurt()

func _on_TelegraphShootTimer_timeout():
	enter_shoot()


func _on_KillTimer_timeout():
	queue_free()
