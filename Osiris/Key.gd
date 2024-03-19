extends KinematicBody2D

export (String, FILE, "*.tscn") var CARRY_OBJECT_PATH = "res://KeyCarry.tscn"
var carry_item

onready var sprite := $Sprite
onready var collider := $CollisionShape2D
onready var area_collider := $Area2D/CollisionShape2D

var gravity = 540
var friction = 200
var velocity = Vector2.ZERO

func _ready():
	carry_item = load(CARRY_OBJECT_PATH)
	
func _physics_process(delta):
	velocity.y += gravity * delta
	velocity.y = min(velocity.y, 200)
	if is_on_floor():
		apply_friction(delta)
	move_and_slide(velocity, Vector2.UP)

func picked_up():
	disable()
		
func drop_item(new_position, throw_dir, added_velocity):
	global_position = Vector2(new_position.x + (throw_dir.x * 14), new_position.y)
	enable()
	velocity += throw_dir.normalized() * Vector2.UP * 100 + added_velocity

func apply_friction(delta):
	velocity.x = move_toward(velocity.x, 0, friction * delta)
	
func disable():
	sprite.visible = false
	collider.set_deferred("disabled", true)
	area_collider.set_deferred("disabled", true)
	
func enable():
	sprite.visible = true
	collider.set_deferred("disabled", false)
	area_collider.set_deferred("disabled", false)
	
func pickup_enabled():
	return true
