extends CPUParticles2D

func _ready():
	pass
	
func set_facing(direction: int):
	scale.x = direction
	restart()

func _on_DespawnTimer_timeout():
	queue_free()
