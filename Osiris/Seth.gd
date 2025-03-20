extends KinematicBody2D

const GRAVITY = 540
onready var sprite := $AnimatedSprite

enum STATE { IDLE, JUMP }
var state = STATE.IDLE
var velocity := Vector2.ZERO
var jump_target := Vector2.ZERO

func _ready():
	enter_idle()

func _physics_process(delta):
	match state:
		STATE.IDLE:
			update_idle(delta)
	
	move_and_slide(velocity, Vector2.UP)

func enter_idle():
	state = STATE.IDLE
	sprite.animation = "Idle"

func enter_jump():
	state = STATE.JUMP
	
func update_idle(delta):
	if not is_on_floor():
		apply_gravity(delta)

func apply_gravity(delta):
	velocity.y += GRAVITY * delta
