extends Node2D

onready var animator := $AnimationPlayer
onready var timer := $Timer

export (Color) var bg_color = Color.black
export (float) var time = 3.0
export (String, FILE, "*.tscn") var next_scene_path

var fade = false

func _ready():
	timer.wait_time = time
	timer.start()
	VisualServer.set_default_clear_color(bg_color)
	Transition.skip_animation()
	AudioManager.play_power_up()
	AudioManager.play_random_thunder()
	
func _input(event):
	if (event.is_action_released("ui_accept") || event.is_action_released("ui_cancel")) && not fade:
		fade = true
		animator.play("FadeOut")

func _on_Timer_timeout():
	if not fade:
		fade = true
	animator.play("FadeOut")

func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene(next_scene_path)
