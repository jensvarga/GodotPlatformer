extends Node2D

export (bool) var test_open = false

onready var gate_collider := $AnimatedSprite/StaticBody2D/GateCollider
onready var sprite := $AnimatedSprite
onready var open := $Open
onready var closed := $Closed

func _ready():
	closed.show()
	open.hide()
	
	if test_open:
		open()
		return
	if Events.has_left_hand:
		open()
		
func open():
	gate_collider.set_deferred("disabled", true)
	sprite.animation = "Open"
	open.show()
	closed.hide()
