extends KinematicBody2D

const JUMP_MUMMY = preload("res://JumpMummy.tscn")
const SPEED = 100

onready var mummy_sprite := $MummySprite

enum { FLOATING, DECENDING, ACENING }
var state = DECENDING

var direction: Vector2
var amplitude: float = 50.0
var frequency: float = 2.0
var jumped = false

var faceing = 1

var time_elapsed: float = 0.0

func _ready():
	faceing = scale.x
	enter_floating()
	
func _physics_process(delta):
	match state:
		DECENDING:
			update_decending()
		ACENING:
			update_acending()
		FLOATING:
			update_floating(delta)

func update_floating(delta):
	time_elapsed += delta

	var horizontal_movement = direction * SPEED * delta * 50
	var vertical_movement = Vector2(0, sin(time_elapsed * frequency) * amplitude)
	var movement = horizontal_movement + vertical_movement
	move_and_slide(movement)
	
func update_decending():
	move_and_slide(direction * SPEED)
	
func update_acending():
	move_and_slide(direction * SPEED)

func enter_floating():
	state = FLOATING
	direction = Vector2(-1 * faceing, 0).normalized()

func enter_decending():
	state = DECENDING
	direction = Vector2(-1 * faceing, 1).normalized()

func enter_acending():
	state = ACENING
	direction = Vector2(-1 * faceing, -1).normalized()
	
func jump():
	enter_acending()
	mummy_sprite.animation = "Hide"
	var jumper = JUMP_MUMMY.instance()
	get_tree().root.get_child(0).add_child(jumper)
	jumper.position = $Position2D.global_position
	var jump_force = Vector2(-20 * faceing, -100)
	jumper.apply_central_impulse(jump_force)
	
	
func _on_PlayerDetect_body_entered(body):
	if body is Player and not jumped:
		mummy_sprite.animation = "Telegraph"
		$JumpTimer.start()
		jumped = true
		
func _on_JumpTimer_timeout():
	jump()
