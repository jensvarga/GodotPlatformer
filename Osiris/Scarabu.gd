extends Enemy

class_name Scarabu

export (int) var MOVE_SPEED = 15
export (int) var MOVE_ACCELERATION = 5 * 60
export (int) var KICKED_SPEED = 150
export (int) var KICKED_TOP_SPEED = 204
export (int) var KICKED_ACCELERATION = 20 * 60
export (int) var DEATH_BOUNCE = -200
enum ColorNames { GREEN, PURPLE }
export (String, "Green", "Purple") var SELECTED_COLOR : String
export (String, FILE, "*.tscn") var CARRY_OBJECT_PATH = "res://GreenShell.tscn"
var carry_item

onready var ledgeCheckRight: = $LedgeCheckRight
onready var ledgeCheckLeft: = $LedgeCheckLeft
onready var hitbox = $Hitbox
onready var hitbox_collider = $Hitbox/CollisionShape2D
onready var sprite = $AnimatedSprite
onready var collision_shape: = $CollisionShape2D
onready var hurt_area_collision: = $HurtBox/CollisionShape2D
onready var hitbox_timer: = $HitboxTimer

#Animations
var walk_anim
var shell_anim
var dead_anim

var frame_counter = 0
var rng = RandomNumberGenerator.new()
var wobble_time:float = 0
var has_hit_wall = false
var carried = false

func _ready():
	carry_item = load(CARRY_OBJECT_PATH)
	if SELECTED_COLOR == "Purple":
		walk_anim = "WalkPurple"
		shell_anim = "ShellPurple"
		dead_anim= "ShellPurple"
	else:
		walk_anim = "Walk"
		shell_anim = "Shell"
		dead_anim= "Dead"
		
	enter_move()
	
func _physics_process(delta):
	match state:
		STASIS:
			update_stasis()
		MOVE:
			update_move(delta)
		SHELL:
			update_shell(delta)
		KICKED:
			update_kicked(delta)
		DEAD:
			update_dead(delta)
	
func enter_move():
	state = MOVE
	hitbox_collider.disabled = false
	sprite.animation = walk_anim
	
func enter_shell():
	set_collision_layer_bit(4, false)
	if not carried:
		hitbox_collider.set_deferred("disabled", true)
	velocity.x = 0
	state = SHELL
	hitbox_collider.disabled = true
	sprite.animation = shell_anim
	
func enter_kicked(dir):
	hitbox_timer.start()
	set_collision_layer_bit(4, true)
	state = KICKED
	hitbox_collider.disabled = false
	direction.x = -dir
	velocity.x = direction.x * KICKED_SPEED
	sprite.animation = shell_anim
	if dir > 0 and sprite.flip_h:
		flip_sprite()
	
func enter_stasis():
	state = STASIS

func enter_dead():
	AudioManager.play_random_hit_sound()
	state = DEAD
	random_spinn = rng.randi_range(-45, 45)
	disable_colliders()
	sprite.animation = dead_anim
	velocity.y = DEATH_BOUNCE
	
func update_kicked(delta):
	sprite_wobbel(delta)
	sprite.scale * direction.x
	var found_wall = is_on_wall()
	if (found_wall and not has_hit_wall) and hitbox_timer.time_left == 0:
		AudioManager.play_random_hit_sound()
		velocity.x = 0
		direction *= -1
		flip_sprite()
		has_hit_wall = true
	elif not found_wall:
		has_hit_wall = false
	
	apply_gravity(delta)
	apply_acceleration(direction.x, KICKED_SPEED, KICKED_ACCELERATION, delta)
	velocity = move_and_slide(velocity, Vector2.UP)

func update_stasis():
	pass
	
func update_dead(delta):
	spinn_sprite(delta)
	apply_gravity(delta)
	velocity = move_and_slide(velocity, Vector2.UP)
	
func update_move(delta):
	var found_wall = is_on_wall()
	var found_ledge_right = not ledgeCheckRight.is_colliding()
	var found_ledge_left = not ledgeCheckLeft.is_colliding()
	var found_ledge = found_ledge_right or found_ledge_left
		
	if (found_wall or found_ledge) and not has_hit_wall:
		direction *= -1
		flip_sprite()
		has_hit_wall = true
	elif not (found_wall or found_ledge):
		has_hit_wall = false
		
	velocity = direction * MOVE_SPEED
	velocity = move_and_slide(velocity, Vector2.UP)
	
func apply_acceleration(direction, speed, acceleration, delta):
	if abs(velocity.x) < speed:
		velocity.x = move_toward(velocity.x, speed * direction, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, KICKED_TOP_SPEED * direction, 0.1 * 60 * delta)

func update_shell(delta):
	apply_gravity(delta)
	velocity = move_and_slide(velocity, Vector2.UP)
	
func flip_sprite():
	sprite.flip_h = not sprite.flip_h
	
func apply_gravity(delta):
	velocity.y += gravity * delta
	velocity.y = min(velocity.y, 200)
	
func die():
	if state != DEAD: enter_dead()
	
func pickup_enabled():
	return state == SHELL

func picked_up():
	disable_colliders()
	carried = true
	enter_stasis()
	sprite.visible = false
	
func drop_item(new_position, new_direction, added_velocity):
	carried = false
	velocity += added_velocity
	position = Vector2(new_position.x + new_direction.x * 25, new_position.y)
	sprite.visible = true
	enable_colliders()
	enter_kicked(new_direction.x * -1)
		
func disable_colliders():
	hitbox_collider.set_deferred("disabled", true)
	hurt_area_collision.set_deferred("disabled", true)
	collision_shape.set_deferred("disabled", true)
	
func enable_colliders():
	hitbox_collider.set_deferred("disabled", false)
	hurt_area_collision.set_deferred("disabled", false)
	collision_shape.set_deferred("disabled", false)
	
func spinn_sprite(delta):
	sprite.rotate(delta * deg2rad(360 + random_spinn))
	
func sprite_wobbel(delta):
	sprite.rotation = sin(wobble_time * 20) * 0.05
	wobble_time += delta

func _on_HitboxTimer_timeout():
	if not carried:
		hitbox_collider.set_deferred("disabled", false)
