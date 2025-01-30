extends Node2D

onready var system1 := $CPUParticles2D2
onready var system2 := $CPUParticles2D

func _ready():
	system1.restart()
	system2.restart()

func _on_Timer_timeout():
	queue_free()
