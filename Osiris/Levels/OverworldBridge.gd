extends Node2D

export(String) var key_item_name

onready var collider := $StaticBody2D/CollisionShape2D
onready var sprite_front := $"../YSort/BridgeFront/Front"
onready var sprite_back := $Back

func _ready():
	if Events.has_pen15:
		open()
	else:
		close()
		
func open():
	collider.set_deferred("disabled", true)
	sprite_front.animation = "Open"
	sprite_back.animation = "Open"

func close():
	collider.set_deferred("disabled", false)
	sprite_front.animation = "Closed"
	sprite_back.animation = "Closed"
