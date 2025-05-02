extends Area2D

var player_on_area := false

func _input(event):
	if not player_on_area:
		return
		
	if not Events.has_all_bodyparts():
		return
	
	if event.is_action_pressed("ui_jump"):
		Events.has_ressurected_osiris = true
		$"..".place_hathor()
		call_deferred("queue_free")

func _on_ReturnBodyTrigger_body_entered(body):
	player_on_area = true

func _on_ReturnBodyTrigger_body_exited(body):
	player_on_area = false
