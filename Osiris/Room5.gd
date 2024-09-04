extends Area2D


func _on_Room5_body_entered(body):
	if body is Player:
		$"../Bubbles".emitting = true
