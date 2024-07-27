extends Node2D

export(String) var key_item_name

onready var collider := $StaticBody2D/CollisionShape2D
onready var sprite_front := $Front
onready var sprite_back := $Back

func _ready():
	if key_item_name in Events.collected_items:
		open()
		
func open():
	collider.set_deferred("disabled", true)
	sprite_front.animation = "Open"
	sprite_back.animation = "Open"
