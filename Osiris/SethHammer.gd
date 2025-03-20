extends RigidBody2D

const GHOST = preload("res://GohstHammer.tscn")

func _on_Timer_timeout():
	var ghost := GHOST.instance()
	get_parent().call_deferred("add_child", ghost)
	ghost.rotation = rotation
	ghost.position = global_position
