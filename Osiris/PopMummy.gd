extends StaticBody2D

export (Vector2) var throw_force = Vector2(-100, -100)

const BONE = preload("res://BoneProjectile.tscn")
const ROCK = preload("res://PopMummyPart.tscn")

onready var sprite := $AnimatedSprite

enum { HIDDEN, THROWING }

var state
var thrown = false
var player_detected = false
var hp: int
	
func _ready():
	hp = 3
	enter_hidden()

func _physics_process(delta):
	match state:
		HIDDEN:
			if player_detected:
				enter_throwing()
		THROWING:
			update_throwing()

func enter_throwing():
	state = THROWING
	sprite.animation = "Throwing"

func enter_hidden():
	state = HIDDEN
	sprite.animation = "Hidden"
	thrown = false
	
func update_throwing():
	if sprite.frame == 3 and not thrown:
		throw_bone()
		return
	if sprite.frame == 6:
		enter_hidden()
		
func explode():
	AudioManager.play_random_explosion_sound()
	$AnimationPlayer.play("RESET")
	for i in range(4):
		var bone = BONE.instance()
		get_tree().root.get_child(4).call_deferred("add_child", bone)
		bone.position = $Position2D.global_position
		bone.apply_central_impulse(Vector2(rand_range(-100, 100), rand_range(-100, -50)))

	for i in range(2):
		var rock = ROCK.instance()
		get_tree().root.get_child(4).call_deferred("add_child", rock)
		rock.position = $Position2D.global_position
		rock.apply_central_impulse(Vector2(rand_range(-150, 150), rand_range(-150, -50)))
		
	queue_free()
	
func on_shot():
	if (hp - 1) <= 0:
		explode()
	else:
		hp -= 1
		AudioManager.play_random_hit_sound()
		$AnimationPlayer.play("Hurt")
		
func throw_bone():
	thrown = true
	var bone = BONE.instance()
	get_tree().root.get_child(4).call_deferred("add_child", bone)
	bone.position = $Position2D.global_position
	bone.apply_central_impulse(throw_force)

func _on_PlayerDetection_body_entered(body):
	if body is Player and state == HIDDEN:
		player_detected = true

func _on_PlayerDetection_body_exited(body):
	if body is Player:
		player_detected = false
