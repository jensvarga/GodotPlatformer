extends StaticBody2D

export (Vector2) var throw_force = Vector2(-100, -100)

const BONE = preload("res://BoneProjectile.tscn")

onready var sprite := $AnimatedSprite

enum { HIDDEN, THROWING }

var state
var thrown = false
var player_detected = false
	
func _ready():
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
	$HitboxPopper/CollisionShape2D.set_deferred("disabled", true)
	thrown = false
	
func update_throwing():
	if sprite.frame == 1:
		$HitboxPopper/CollisionShape2D.set_deferred("disabled", false)
	if sprite.frame == 3 and not thrown:
		throw_bone()
		return
	if sprite.frame == 6:
		enter_hidden()
	
func throw_bone():
	thrown = true
	var bone = BONE.instance()
	get_tree().root.get_child(0).add_child(bone)
	bone.position = $Position2D.global_position
	bone.apply_central_impulse(throw_force)

func _on_PlayerDetection_body_entered(body):
	if body is Player and state == HIDDEN:
		player_detected = true

func _on_PlayerDetection_body_exited(body):
	if body is Player:
		player_detected = false
