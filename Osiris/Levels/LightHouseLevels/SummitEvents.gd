extends Node2D

var at_gate = false

func _ready():
	Events.has_talaria = true
	Events.has_power_crook = true
	if Events.check_point_reached:
		Events.set_deferred("player_hit_points", Events.max_player_hit_points)

func _input(event):
	if event.is_action_released("ui_up") and at_gate:
		at_gate = false
		AudioManager.play_random_checkpoint_sound()
		AudioManager.play_key_sound()
		Events.emit_signal("stage_cleared")

func _on_Area2D_body_entered(body):
	if body is Player:
		at_gate = true

func _on_Area2D_body_exited(body):
	if body is Player:
		at_gate = false
