extends RigidBody2D

const GHOST = preload("res://GohstHammer.tscn")

func _on_Timer_timeout():
	var ghost := GHOST.instance()
	get_parent().call_deferred("add_child", ghost)
	ghost.rotation = rotation
	ghost.position = global_position
	
func destroy():
	call_deferred("queue_free")

func _on_Area2D_body_entered(body):
	if body is Player:
		AudioManager.play_boom()
		body.hurt()
		destroy()

func _on_VisibilityNotifier2D_screen_exited():
	destroy()
