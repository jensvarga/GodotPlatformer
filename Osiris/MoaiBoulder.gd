extends RigidBody2D

const PARTS := preload("res://BoulderParticles.tscn")

func _on_Area2D_body_entered(body):
	if body == self:
		return
	if body is Player:
		body.hurt()
	
	var parts := PARTS.instance()
	get_parent().call_deferred("add_child", parts)
	parts.position = global_position
	call_deferred("queue_free")
