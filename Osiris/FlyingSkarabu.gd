extends Enemy

onready var sprite: = $AnimatedSprite
onready var hitbox_collider: = $Hitbox/CollisionShape2D
onready var remove_timer := $"../../RemoveTimer"

func _ready():
	sprite.animation = "Fly"
	state = FLYING
	
func _physics_process(delta):
	if state == DEAD:
		apply_gravity(delta)
		velocity = move_and_slide(velocity, Vector2.UP)

func die():
	sprite.animation = "Dead"
	state = DEAD
	remove_timer.start()

func _on_RemoveTimer_timeout():
	queue_free()
