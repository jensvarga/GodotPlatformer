extends Path2D

enum { ENTRANCE, IDLE }
var state = ENTRANCE

onready var head_sprite: = $PathFollow2D/AnimatedSprite
onready var tail_sprite: = $Path2D/PathFollow2D/AnimatedSprite

func _ready():
	hide_sprites()
	head_sprite.animation = "Entrance"
	tail_sprite.animation = "Entrance"

func _physics_process(delta):
	match state:
		ENTRANCE:
			update_entrance(delta)
		IDLE:
			update_idle(delta)
# Enter states
func enter_idle():
	state = IDLE
	head_sprite.animation = "Idle"
	tail_sprite.animation = "Idle"
	
# Update states
func update_entrance(delta):
	pass
	
func update_idle(delta):
	pass
	
# Helpers
func hide_sprites():
	head_sprite.visible = false
	tail_sprite.visible = false
	
func show_sprites():
	head_sprite.visible = true
	tail_sprite.visible = true
	
	
