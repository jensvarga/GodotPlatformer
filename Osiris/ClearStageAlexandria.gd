extends Area2D

func _on_Area2D_body_entered(body):
	Events.emit_signal("stage_cleared")
