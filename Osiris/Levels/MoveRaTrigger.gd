extends Area2D

onready var ra := $"../YSort/RA"

func _on_MoveRaTrigger_body_entered(body):
	ra.queue_free()
	queue_free()
