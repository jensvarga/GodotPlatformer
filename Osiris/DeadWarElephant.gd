extends RigidBody2D

const SPLAT := preload("res://BirdSplat.tscn")

onready var parts := $CPUParticles2D

func _ready():
	var splat := SPLAT.instance()
	splat.position = global_position
	get_parent().call_deferred("add_chikd", splat)
	parts.restart()

func _on_Timer_timeout():
	call_deferred("queue_free")
