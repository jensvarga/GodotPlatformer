extends Area2D

onready var sprite: = $AnimatedSprite
onready var attack_delay: = $AttackDelay
onready var attack_time: = $AttackTime
onready var hitbox: = $KinematicBody2D/CollisionShape2D

enum { IDLE, ATTACK, FROZEN }
var state = IDLE

var player
var in_death_zone = false

func _physics_process(delta):
	match state:
		IDLE:
			update_idle()
		ATTACK:
			update_attack()
		FROZEN:
			update_frozen()

func enter_idle():
	state = IDLE
	sprite.animation = "Idle"

func enter_attack():
	state = ATTACK
	sprite.animation = "Attack"
	attack_time.start()

func update_idle():
	pass
	
func update_frozen():
	pass
	
func enter_frozen():
	state = FROZEN
	sprite.animation = "Frozen"
	
func update_attack():
	if in_death_zone:
		kill_player()
	
func _ready():
	sprite.animation = "Idle"

func _on_Crocky_body_entered(body):
	if state == FROZEN: return
	if body is Player:
		player = body
		if state == IDLE:
			sprite.animation = "Stepped"
			in_death_zone = true
			attack_delay.start()
		if state == ATTACK:
			kill_player()

func kill_player():
	player.die()
	enter_frozen()
	
func _on_AttackDelay_timeout():
	if state != FROZEN:
		enter_attack()

func _on_AttackTime_timeout():
	if state != FROZEN:
		enter_idle()

func _on_Crocky_body_exited(body):
	if body is Player:
		in_death_zone = false
