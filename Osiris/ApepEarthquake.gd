extends Node2D

func _ready():
	CameraShaker.add_trauma(0.4)

func _on_Rock_body_entered(body):
	if body is Player:
		body.hurt()
		body.bounce(200)

func destroy():
	call_deferred("queue_free")
