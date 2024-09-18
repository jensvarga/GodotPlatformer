extends KinematicBody2D

class_name ThrowableRock

onready var sprite: = $AnimatedSprite
onready var collider: = $CollisionShape2D
onready var hitbox: = $Area2D/CollisionShape2D

export (int) var GRAVITY = 540 * 10
export (String, FILE, "*.tscn") var CARRY_OBJECT_PATH = "res://RockCarryItem.tscn"
export (String, FILE, "*.tscn") var THROW_OBJECT_PATH = "res://ThrowingRock.tscn"
var carry_item
var throw_item

var velocity = Vector2.ZERO
var direction = Vector2.LEFT

enum { STATIC, CARRIED, AIR }
var state = STATIC

func _ready():
	carry_item = load(CARRY_OBJECT_PATH)
	
func _physics_process(delta):
	match state:
		STATIC:
			update_static(delta)
		CARRIED:
			update_carried(delta)
		AIR:
			update_air(delta)
			
func enter_static():
	state = STATIC
	
func enter_carried():
	state = CARRIED
	disable()
	
func enter_air():
	state = AIR
	
func update_static(delta):
	if not is_on_floor():
		enter_air()
		return
	
func update_carried(delta):
	pass
	
func update_air(delta): 
	if is_on_floor():
		enter_static()
		return
		
	apply_gravity(delta)
	velocity = move_and_slide(velocity, Vector2.UP)
			
func _on_Area2D_body_entered(body):
	match state:
		STATIC:
			pass
		CARRIED:
			pass
		AIR:
			if body is Player:
				body.hurt()

# Helpers
func apply_gravity(delta):
	velocity.y += GRAVITY * delta
	velocity.y = min(velocity.y, 200 * 2)
	
func apply_acceleration(direction, speed, acceleration, delta):
	velocity.x = move_toward(velocity.x, speed * direction, acceleration * delta)
	
func picked_up():
	enter_carried()
	
func drop_item(new_position, throw_dir, added_velocity):
	throw_item = load(THROW_OBJECT_PATH)
	var throw_instance = throw_item.instance()
	call_deferred("add_child", throw_instance)
	
	if throw_instance.has_method("instanciate"):
		throw_instance.instanciate(new_position, throw_dir, added_velocity)
	else:
		print("no method called instanciate")
		
	#queue_free()
	
func pickup_enabled():
	return state == STATIC
	
func disable():
	collider.set_deferred("disabled", true)
	hitbox.set_deferred("disabled", true)
	sprite.visible = false
	
func enable():
	collider.set_deferred("disabled", false)
	hitbox.set_deferred("disabled", false)
	sprite.visible = true
	
func destroy():
	queue_free()
