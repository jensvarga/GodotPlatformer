extends Area2D
var colliding = false

var held_button = false

func _physics_process(delta):
	if not colliding: return
	
	if held_button:
		Events.emit_signal("stage_cleared")
		
func _input(event):
	if event.is_action_pressed("move_left"):
		held_button = true
	if event.is_action_released("move_left"):
		held_button = false
		
func _on_ClearLevelArea_body_entered(body):
	if body is Player:
		colliding = true

func _on_ClearLevelArea_body_exited(body):
	if body is Player:
		colliding = false

