extends RigidBody2D

const PART := preload("res://LavaDropParticles.tscn")

func _on_Area2D_body_entered(body):
	if body == self:
		return
	if body is Player:
		body.hurt()
	
	explode()
func explode():
	var part := PART.instance()
	get_parent().call_deferred("add_child", part)
	part.position = global_position
	AudioManager.play_lava_drop()
	queue_free()

func _on_Area2D_area_entered(area):
	if area.collision_layer & 1 != 0:
		explode()
