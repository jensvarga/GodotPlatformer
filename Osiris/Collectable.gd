extends Node2D

export(Resource) var collectable_resource

var collected = false

onready var sprite := $Sprite

func _ready():
	sprite.texture = collectable_resource.texture
	
func _on_PickupArea_body_entered(body):
	if body is Player and !collected and collectable_resource.has_method("collect_action"):
		collected = true
		Events.has_left_hand = true
		sprite.hide()
		collectable_resource.collect_action()
