extends Area2D

func _ready():
	$"../Bubbles".emitting = false

func _on_Room3_body_entered(body):
	if body is Player:
		$"../Bubbles".emitting = false
