extends Node2D

func _ready():
	$CPUParticles2D.restart()
	$CPUParticles2D2.restart()
	$CPUParticles2D3.restart()
	$CPUParticles2D4.restart()

func _on_Timer_timeout():
	queue_free()
