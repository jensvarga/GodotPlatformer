extends Path2D

export (int) var hit_points = 50
export (String, FILE, "*.tscn") var ROCK_OBJECT_PATH = "res://ThrowableRock.tscn"
var rock_object

enum { ENTRANCE, IDLE, HURT, TELEGRAPH, TAIL_ATTACK, DEAD, TELEGRAPH_BITE, BITE_ATTACK, EXIT_BITE, TELEGRAPH_LAZER, LAZER_ATTACK, EXIT_LAZER}
var state = ENTRANCE

onready var head_sprite: = $PathFollow2D/AnimatedSprite
onready var tail_sprite: = $Path2D/PathFollow2D/AnimatedSprite
onready var animation_player: = $AnimationPlayer
onready var collider: = $PathFollow2D/AnimatedSprite/KinematicBody2D/CollisionShape2D
onready var telegraph_timer: = $TelegraphTimer
onready var attack_sprite: = $TailAttackPathRight/PathFollow2D/AnimatedSprite
onready var rock_timer: = $RockTimer
onready var state_timer: = $StateTimer
onready var bite_timer: = $BiteTimer
onready var lazer_telegraph_timer: = $LazerTelegraphTimer
onready var lazer_sprite: = $LazerAttackSprite
onready var lazer_beam_1: = $LazerAttackSprite/LaserBeam2D
onready var lazer_beam_2: = $LazerAttackSprite/LaserBeam2D2


var RIGHT_DROPS : Array
var LEFT_DROPS : Array

var attack_direction = 1
var velocity = Vector2.ZERO
var move_speed = 30

var lazer_telegraph_second_face = false
var lazer_index = 0
var lazer_active = false
const HISTORY_LENGTH = 30
var player_history: = []
var player

var prevoius_state = IDLE

func _ready():
	RIGHT_DROPS = [
		$RightDrop1,
		$RightDrop2,
		$RightDrop3,
		$RightDrop4
	]
	LEFT_DROPS = [
		$LeftDrop1,
		$LeftDrop2,
		$LeftDrop3,
		$LeftDrop4
	]
		
	rock_object = load(ROCK_OBJECT_PATH)
	lazer_sprite.visible = false
	if not Events.check_point_reached:
		hide_sprites()
		head_sprite.animation = "Entrance"
		tail_sprite.animation = "Entrance"
		collider.set_deferred("disabled", true)
	else:
		enter_idle()

func _physics_process(delta):
	match state:
		ENTRANCE:
			update_entrance(delta)
		IDLE:
			update_idle(delta)
		HURT:
			update_hurt(delta)
		TELEGRAPH:
			update_telegraph(delta)
		TAIL_ATTACK:
			update_tail_attack(delta)
		TELEGRAPH_BITE:
			update_telegraph_bite(delta)
		BITE_ATTACK:
			update_bite(delta)
		EXIT_BITE:
			update_exit_bite(delta)
		TELEGRAPH_LAZER:
			update_telegraph_lazer(delta)
		LAZER_ATTACK:
			update_lazer_attack(delta)
		EXIT_LAZER:
			update_exit_lazer(delta)
		DEAD:
			pass

# Enter states
func enter_idle():
	state_timer.start()
	state = IDLE
	collider.set_deferred("disabled", false)
	head_sprite.animation = "Idle"
	tail_sprite.animation = "Idle"
	animation_player.play("Idle")
	if not head_sprite.visible:
		head_sprite.visible = true
	if not tail_sprite.visible:
		tail_sprite.visible = true
	
func enter_hurt():
	prevoius_state = state
	state = HURT
	AudioManager.play_aphopis_hurt_sound()
	CameraShaker.add_trauma(0.5)
	head_sprite.animation = "Hurt"
	tail_sprite.animation = "Hurt"
	
func enter_dead():
	state = DEAD
	
func enter_telegraph():
	tail_sprite.animation = "Idle"
	collider.set_deferred("disabled", true)
	tail_sprite.scale.x *= attack_direction
	state = TELEGRAPH
	AudioManager.play_aphopis_telegraph_sound()
	tail_sprite.animation = "Telegraph"
	telegraph_timer.start()

func enter_telegraph_bite():
	state = TELEGRAPH_BITE
	bite_timer.start()
	tail_sprite.animation = "Idle"
	collider.set_deferred("disabled", true)

func exit_bite():
	state = EXIT_BITE
	bite_timer.start()
	
func enter_tail_attack():
	state = TAIL_ATTACK
	tail_sprite.visible = false
	rock_timer.start()
	attack_sprite.animation = "Attack"
	if tail_sprite.scale.x > 0:
		animation_player.play("Attack")
	else:
		animation_player.play("AttackLeft")

func enter_bite():
	state = BITE_ATTACK
	bite_timer.start()
	if attack_direction < 0:
		animation_player.play("BiteAttackLeft")
	else:
		animation_player.play("BiteAttackRight")

func enter_telegraph_lazer():
	state = TELEGRAPH_LAZER
	tail_sprite.animation = "Idle"
	collider.set_deferred("disabled", true)
	player = get_node("/root/AphopisLevel/PlayerRoot/Player")
	lazer_sprite.visible = true
	lazer_telegraph_second_face = false
	lazer_telegraph_timer.start()
	
func enter_lazer():
	state = LAZER_ATTACK
	activate_lazers(true)
	lazer_switching()

func exit_lazer():
	state = EXIT_LAZER
	activate_lazers(false)
	lazer_telegraph_second_face = false
	lazer_telegraph_timer.start()
	
# Update states
func update_entrance(delta):
	pass
	
func update_idle(delta):
	update_player_history()

func update_hurt(delta):
	pass
	
func update_telegraph(delta):
	pass

func update_telegraph_bite(delta):
	var movement = Vector2(attack_direction, 1) * move_speed * delta
	head_sprite.position += movement

func update_telegraph_lazer(delta):
	if lazer_telegraph_second_face:
		var movement = Vector2.DOWN * move_speed * delta * 1.5
		lazer_sprite.position += movement
	else:	
		var movement = Vector2.LEFT * move_speed * delta * 2
		head_sprite.position += movement
		
func update_exit_lazer(delta):
	if lazer_telegraph_second_face:
		var movement = Vector2.LEFT * move_speed * delta * 2
		head_sprite.position -= movement
	else:
		var movement = Vector2.DOWN * move_speed * delta * 1.5
		lazer_sprite.position -= movement
		
func update_lazer_attack(delta):
	update_player_history()
	if player_history.size() < HISTORY_LENGTH: return
	lazer_beam_1.direction = (player_history[0] - lazer_beam_1.global_position).normalized()
	lazer_beam_2.direction = (player_history[0] - lazer_beam_2.global_position).normalized()
	
func update_exit_bite(delta):
	var movement = Vector2(attack_direction, 1) * move_speed * delta
	head_sprite.position -= movement
	
func update_tail_attack(delta):
	pass
	
func update_bite(delta):
	pass
	
# Helpers
func hide_sprites():
	head_sprite.visible = false
	tail_sprite.visible = false
	
func show_sprites():
	head_sprite.visible = true
	tail_sprite.visible = true
	
func hurt():
	if hit_points - 1 <= 0:
		enter_dead()
	else:
		hit_points -= 1
		enter_hurt()
	
	print("hit points:", hit_points)
	
func spawn_rock_right():
	if RIGHT_DROPS.size() > 0:
		var random_index = randi() % RIGHT_DROPS.size()
		spawn_rock_at(RIGHT_DROPS[random_index])
		
func spawn_rock_left():
	if LEFT_DROPS.size() > 0:
		var random_index = randi() % LEFT_DROPS.size()
		spawn_rock_at(LEFT_DROPS[random_index])

func spawn_random_rock():
	var rand = randi() % 2
	match rand:
		0:
			spawn_rock_right()
		1:
			spawn_rock_left()
			
func spawn_rock_at(drop_node):
	var rock_instance = rock_object.instance()
	drop_node.add_child(rock_instance)
	rock_instance.scale = Vector2(0.5, 0.5)
	CameraShaker.add_trauma(0.7)
	AudioManager.play_random_explosion_sound()
	
func select_attack_state():
	if rand_range(-1, 1) < 0:
		attack_direction *= -1
			
	var rand = randi() % 3
	match rand:
		0:
			enter_telegraph_lazer()
		1:
			enter_telegraph_bite()
		2:
			enter_telegraph()
	
func activate_lazers(boolean: bool):
	lazer_active = boolean
	
func lazer_switching():
	while lazer_active:
		CameraShaker.add_trauma(0.5)
		lazer_beam_1.activate(true)
		lazer_beam_2.activate(false)
		yield(get_tree().create_timer(1.0), "timeout")

		lazer_beam_1.activate(false)
		lazer_beam_2.activate(false)
		yield(get_tree().create_timer(0.5), "timeout")
		
		CameraShaker.add_trauma(0.5)
		lazer_beam_1.activate(false)
		lazer_beam_2.activate(true)
		yield(get_tree().create_timer(1.0), "timeout")
		
		lazer_beam_1.activate(false)
		lazer_beam_2.activate(false)
		yield(get_tree().create_timer(0.7), "timeout")
		
		CameraShaker.add_trauma(0.7)
		spawn_random_rock()
		lazer_beam_1.activate(true)
		lazer_beam_2.activate(true)
		yield(get_tree().create_timer(1.0), "timeout")
		
		lazer_beam_1.activate(false)
		lazer_beam_2.activate(false)
		yield(get_tree().create_timer(1), "timeout")
		
		lazer_active = false
		exit_lazer()

func update_player_history():
	if player == null: return
	player_history.push_back(player.global_position)
	while player_history.size() > HISTORY_LENGTH:
		player_history.remove(0)
		
func _on_AnimatedSprite_animation_finished():
	if state == HURT:
		enter_idle()

func _on_TelegraphTimer_timeout():
	enter_tail_attack()

func _on_AnimationPlayer_animation_finished(anim_name):
	if state == TAIL_ATTACK:
		enter_idle()

func _on_RockTimer_timeout():
	if state == BITE_ATTACK:
		spawn_rock_left()
		spawn_rock_right()
		return
		
	if tail_sprite.scale.x > 0:
		spawn_rock_left()
	else:
		spawn_rock_right()

func _on_HitareaRight_body_entered(body):
	hit_body(body)
	
func _on_HitareaLeft_body_entered(body):
	hit_body(body)
	
func hit_body(body):
	if body is Player:
		body.die()
	if body is ThrowableRock:
		body.destroy()
	AudioManager.play_random_explosion_sound()

func _on_StateTimer_timeout():
	state_timer.wait_time = rand_range(1, 4)
	select_attack_state()

func _on_BiteAreaLeft_body_entered(body):
	hit_body(body)

func _on_BiteAreaRight_body_entered(body):
	hit_body(body)

func _on_BiteTimer_timeout():
	if state == TELEGRAPH_BITE:
		enter_bite()
	elif state == BITE_ATTACK:
		exit_bite()
	else:
		enter_idle()
			
func _on_LazerTelegraphTimer_timeout():
	if lazer_telegraph_second_face:
		if state == TELEGRAPH_LAZER:
			enter_lazer()
		elif state == EXIT_LAZER:
			lazer_sprite.visible = false
			enter_idle()
	else:
		if state == TELEGRAPH_LAZER:
			head_sprite.visible = false
		elif state == EXIT_LAZER:
			head_sprite.visible = true
			
		lazer_telegraph_second_face = true
		lazer_telegraph_timer.start()
