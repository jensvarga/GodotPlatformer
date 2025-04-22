extends Node2D

var at_gate = false

onready var ankh1 := $"../Ankh"
onready var ankh2 := $"../Ankh2"

func _ready():
	Events.has_talaria = true
	Events.has_power_crook = true
	if Events.check_point_reached:
		ankh1.call_deferred("queue_free")
		ankh2.call_deferred("queue_free")

func _input(event):
	if event.is_action_pressed("ui_up") and at_gate:
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
