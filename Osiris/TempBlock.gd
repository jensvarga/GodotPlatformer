extends StaticBody2D

onready var sprite := $Sprite
onready var collider := $CollisionShape2D

func _ready():
	sprite.hide()
	
func unlock():
	collider.set_deferred("disabled", true)
