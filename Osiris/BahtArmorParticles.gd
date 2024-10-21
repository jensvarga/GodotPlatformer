extends CPUParticles2D

func _ready():
	restart()
	$CPUParticles2D.restart()

func _on_Timer_timeout():
	queue_free()
