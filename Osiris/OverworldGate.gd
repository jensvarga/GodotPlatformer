extends Node2D

export(String) var key_item_name
export (bool) var test_open = false

onready var gate_collider := $AnimatedSprite/StaticBody2D/GateCollider
onready var sprite := $AnimatedSprite

func _ready():
	if test_open:
		open()
		return
	if key_item_name in Events.collected_items:
		open()
		
func open():
	gate_collider.set_deferred("disabled", true)
	sprite.animation = "Open"
