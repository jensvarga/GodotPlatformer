extends Area2D

var colliding = false

func _physics_process(delta):
	if not colliding: return
	
	if Input.is_action_just_pressed("ui_up"):
		Events.emit_signal("stage_cleared")

func _on_Gate_body_entered(body):
	if body is Player:
		colliding = true
		

func _on_Gate_body_exited(body):
	if body is Player:
		colliding = false
