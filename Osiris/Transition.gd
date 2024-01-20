extends CanvasLayer

onready var animation_player: = $AnimationPlayer

signal transition_started
signal transition_completed

func _ready():
	pass
	
func play_start_transition():
	animation_player.play("StartLevel")
	
func play_exit_transition():
	animation_player.play("ExitLevel")
	
func _on_AnimationPlayer_animation_started(anim_name):
	emit_signal("transition_started")


func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("transition_completed")
