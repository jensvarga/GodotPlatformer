extends Path2D

export (float) var offset = 0
export (float) var custom_speed = 1

onready var animation_player := $AnimationPlayer

func _ready():
	animation_player.playback_speed = custom_speed
	animation_player.play("Loop")
	animation_player.seek(offset, true)
	
func _on_Area2D_body_entered(body):
	if body is Player:
		body.hurt()
