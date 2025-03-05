extends Node2D

export (bool) var on = true
export (float, 0.0, 6.0) var offset = 0.0

onready var animation_player := $AnimationPlayer
onready var sprite := $LavaFall

func _ready():
	if on:
		animation_player.play("IncreaseGap")
		animation_player.seek(offset, true)
	else:
		animation_player.stop()
		sprite.material.set_shader_param("flow_gaps", 0.33)

func _on_Area2D_body_entered(body):
	if body is Player:
		body.hurt()
	elif body.has_method("die"):
		body.die()

func _on_VisibilityNotifier2D_screen_entered():
	AudioManager.play_lava_sound()

func _on_VisibilityNotifier2D_screen_exited():
	AudioManager.stop_lava_sound()
