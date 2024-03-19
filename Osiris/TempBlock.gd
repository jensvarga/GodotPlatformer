extends StaticBody2D

export (int) var gate_index
# Add gate to gates dictionary in Events.gd

onready var sprite := $Sprite
onready var collider := $CollisionShape2D

func _ready():
	sprite.hide()
	if Events.gates[gate_index]:
		unlock()
	
	
func unlock():
	collider.set_deferred("disabled", true)
