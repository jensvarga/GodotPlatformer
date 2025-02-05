extends Node2D

onready var explo_parts := $FireParticles2

func _ready():
	explo_parts.restart()

func _on_Timer_timeout():
	call_deferred("queue_free")

func _on_Area2D_body_entered(body):
	if body is Player:
		body.hurt()
