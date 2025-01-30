extends CanvasLayer

onready var animation_player: = $AnimationPlayer
onready var rect := $ColorRect
onready var pixel_rect := $ColorRect2

signal transition_started
signal transition_completed
signal pixelation_completed

func _ready():
	pass
	
func skip_animation():
	rect.hide()

func pixelate():
	pixel_rect.show()
	animation_player.play("Pixelate")

func pixelation_completed():
	emit_signal("pixelation_completed")
	
func play_start_transition():
	pixel_rect.hide()
	rect.show()
	animation_player.play("StartLevel")
	
func play_exit_transition():
	rect.show()
	animation_player.play("ExitLevel")
	
func _on_AnimationPlayer_animation_started(anim_name):
	emit_signal("transition_started")

func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("transition_completed")
