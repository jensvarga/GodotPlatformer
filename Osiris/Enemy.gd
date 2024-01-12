extends KinematicBody2D

class_name Enemy

enum { STASIS, MOVE, SHELL, KICKED, FLYING, DEAD, AIM, IDLE, ATTACK, FROZEN }
var state = MOVE
var previous_state = MOVE
var random_spinn = 0
var velocity = Vector2.ZERO
var gravity = 540
var direction = Vector2.LEFT
var dead = false

func _ready():
	Events.connect("player_died", self, "_on_player_died")
	
func die():
	AudioManager.play_random_hit_sound()
	queue_free()

func apply_gravity(delta):
	velocity.y += gravity * delta

func attack(body):
	pass

func _on_player_died():
	pass
