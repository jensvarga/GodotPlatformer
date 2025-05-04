extends Area2D

var player_on_area := false

func _input(event):
	if not player_on_area:
		return
		
	if not Events.has_all_bodyparts():
		return
	
	if event.is_action_pressed("ui_jump") and player_on_area and Events.has_all_bodyparts():
		Events.has_ressurected_osiris = true
		Events.emit_signal("returned_body")
		$"..".place_hathor()
		call_deferred("queue_free")

func _on_ReturnBodyTrigger_body_entered(body):
	if body is OverworldPlayer:
		player_on_area = true

func _on_ReturnBodyTrigger_body_exited(body):
	if body is OverworldPlayer:
		player_on_area = false
