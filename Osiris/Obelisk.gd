extends Area2D

onready var sprite: = $AnimatedSprite

func _ready():
	if Events.check_point_reached:
		sprite.animation = "Active"
	else:
		sprite.animation = "Inactive"
	
func _on_Obelisk_body_entered(body):
	if body is Player and not Events.check_point_reached:
		AudioManager.play_random_checkpoint_sound()
		sprite.animation = "Active"
		Events.emit_signal("checkpoint_reached")
