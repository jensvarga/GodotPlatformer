extends StaticBody2D

export (bool) var close = false
export (bool) var open = false

var door_is_closed = false

onready var sprite := $AnimatedSprite
onready var shape := $CollisionShape2D
 
func _ready():
	sprite.animation = "Open"
	
func _physics_process(delta):
	if close and not door_is_closed:
		close_gate()
		close = false
	if open and door_is_closed:
		open_gate()
		open = false
	
func close_gate():
	sprite.animation = "Closing"
	CameraShaker.add_trauma(0.3)
	shape.scale.y = 2
	door_is_closed = true

func open_gate():
	sprite.animation = "Opening"
	CameraShaker.add_trauma(0.3)
	shape.scale.y = 1
	door_is_closed = false
