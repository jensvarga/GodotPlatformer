extends Node2D

export(Resource) var collectable_resource

var amplitude = 5
var speed = .5
var initial_position: Vector2
var collected = false

onready var sprite := $Sprite

func _ready():
	sprite.texture = collectable_resource.texture
	initial_position = position

func _physics_process(delta):
	var offset = amplitude * sin(speed * OS.get_ticks_msec() * 0.001)
	var new_position = initial_position + Vector2(0, offset)
	position = new_position
	
func _on_PickupArea_body_entered(body):
	if body is Player and !collected and collectable_resource.has_method("collect_action"):
		collected = true
		sprite.hide()
		collectable_resource.collect_action()
