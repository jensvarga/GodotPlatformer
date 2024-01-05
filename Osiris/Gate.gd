extends Area2D

func _on_Gate_body_entered(body):
	if body is Player and Input.is_action_just_pressed("ui_up"):
		Events.emit_signal("stage_cleared")
