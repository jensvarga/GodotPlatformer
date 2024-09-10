extends RigidBody2D

const PART = preload("res://WheelParticles.tscn")

func _on_Area2D_area_entered(area):
	if area is SphinxBody:
		area.hurt()
		var part = PART.instance()
		get_parent().add_child(part)
		part.position = global_position
		
		queue_free()
