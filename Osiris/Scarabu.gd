extends Enemy

class_name Scarabu

export (int) var MOVE_SPEED = 15
export (int) var MOVE_ACCELERATION = 5 * 60
export (int) var KICKED_SPEED = 150
export (int) var KICKED_TOP_SPEED = 204
export (int) var KICKED_ACCELERATION = 20 * 60
export (int) var DEATH_BOUNCE = -200

onready var ledgeCheckRight: = $LedgeCheckRight
onready var ledgeCheckLeft: = $LedgeCheckLeft
onready var hitbox = $Hitbox
onready var hitbox_collider = $Hitbox/CollisionShape2D
onready var sprite = $AnimatedSprite
onready var collision_shape: = $CollisionShape2D
onready var hurt_area_collision: = $HurtBox/CollisionShape2D
onready var hitbox_timer: = $HitboxTimer

var frame_counter = 0
var rng = RandomNumberGenerator.new()
var wobble_time:float = 0
var has_hit_wall = false

func _ready():
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
	sprite.animation = "Walk"
	
func enter_shell():
	set_collision_layer_bit(4, false)
	hitbox_collider.set_deferred("disabled", true)
	velocity.x = 0
	state = SHELL
	hitbox_collider.disabled = true
	sprite.animation = "Shell"
	
func enter_kicked(dir):
	hitbox_timer.start()
	set_collision_layer_bit(4, true)
	state = KICKED
	hitbox_collider.disabled = false
	direction.x = -dir
	velocity.x = direction.x * KICKED_SPEED
	sprite.animation = "Shell"
	if dir > 0 and sprite.flip_h:
		flip_sprite()
	
func enter_stasis():
	state = STASIS

func enter_dead():
	AudioManager.play_random_hit_sound()
	state = DEAD
	random_spinn = rng.randi_range(-45, 45)
	disable_colliders()
	sprite.animation = "Dead"
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
	
func disable_colliders():
	hitbox_collider.set_deferred("disabled", true)
	hurt_area_collision.set_deferred("disabled", true)
	collision_shape.set_deferred("disabled", true)
	
func spinn_sprite(delta):
	sprite.rotate(delta * deg2rad(360 + random_spinn))
	
func sprite_wobbel(delta):
	sprite.rotation = sin(wobble_time * 20) * 0.05
	wobble_time += delta

func _on_VisibilityNotifier2D_screen_entered():
	state = previous_state

func _on_VisibilityNotifier2D_screen_exited():
	previous_state = state
	enter_stasis()

func _on_HitboxTimer_timeout():
	hitbox_collider.set_deferred("disabled", false)
