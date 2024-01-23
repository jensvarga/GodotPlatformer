extends Node2D

onready var animation_player := $AnimationPlayer
onready var path_follow := $Path2D/PathFollow2D
onready var yellow_pyramid_sprite := $YellowPyramid

export (String, FILE, "*.tscn") var level_1 := "res://Levels/Level1.tscn"
export (String, FILE, "*.tscn") var level_2 := "res://Levels/Level2.tscn"
var next_level_path

var current_level = 1
var ready = true

func _ready():
	Transition.connect("transition_started", self, "_on_transition_started")
	Transition.connect("transition_completed", self, "_on_transition_completed")
	path_follow.unit_offset = 0
	Transition.play_start_transition()
	AudioManager.play_reaper()
	
func _process(delta):
	yellow_pyramid_sprite.visible = Events.unlocked_level_2
	
	if current_level == 1:
		if Input.is_action_just_pressed("ui_right") && Events.unlocked_level_2:
			ready = false
			animation_player.play("1-2")
			current_level = 2
	if current_level == 2:
		if Input.is_action_just_pressed("ui_left"):
			ready = false
			animation_player.play_backwards("1-2")
			current_level = 1
	if Input.is_action_just_pressed("ui_jump"):
		start_selected_level()

func start_selected_level():
	if not ready: return
	AudioManager.play_random_checkpoint_sound()
	Transition.play_exit_transition()
	if current_level == 2:
		next_level_path = level_2
	else:
		next_level_path = level_1

func _on_transition_started():
	pass
	
func _on_transition_completed():
	if next_level_path == null: return
	get_tree().change_scene(next_level_path)
	
func _on_AnimationPlayer_animation_finished(anim_name):
	ready = true
