extends AnimatedSprite

onready var collider: = $KinematicBody2D/CollisionShape2D

func _ready():
	Events.connect("checkpoint_reached", self, "_on_checkpoint_reached")
	if not Events.check_point_reached:
		collider.set_deferred("disabled", true)
	else:
		animation = "Closed"
		
func open():
	animation = "Open"
	collider.set_deferred("disabled", true)
	
func close():
	animation = "Close"
	collider.set_deferred("disabled", false)
	
func _on_checkpoint_reached():
	close()
