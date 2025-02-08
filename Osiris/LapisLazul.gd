extends Node2D

export var lapis_id = ""

func _ready():
	if Events.lapis_ids.has(lapis_id):
		queue_free()

func _on_Area2D_body_entered(body):
	if body is Player:
		AudioManager.play_random_checkpoint_sound()
		Events.lapis_ids.append(lapis_id)
		Events.emit_signal("update_lapis_count")
		call_deferred("queue_free")
