extends Node2D

func _ready():
	$CPUParticles2D.restart()

func _on_Timer_timeout():
	queue_free()
