extends Path2D

onready var animation_player := $AnimationPlayer

var reset = true

func _on_Area2D_body_entered(body):
	if body is Player:
		animation_player.play("Attack")
		if reset:
			AudioManager.play_roar()
			reset = false

func _on_Hitbox_body_entered(body):
	if body is Player:
		body.hurt()

func _on_BounceBox_body_entered(body):
	if body is Player:
		body.bounce(300)


func _on_AnimationPlayer_animation_finished(anim_name):
	reset = true
