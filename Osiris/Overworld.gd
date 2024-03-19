extends Node2D

onready var animation_player := $AnimationPlayer
onready var path_follow := $Path2D/PathFollow2D
onready var yellow_pyramid_sprite := $YellowPyramid
onready var yellow_level_3 := $YellowLevel

export (String, FILE, "*.tscn") var level_1 := "res://Levels/Level1.tscn"
export (String, FILE, "*.tscn") var level_2 := "res://Levels/Level2.tscn"
export (String, FILE, "*.tscn") var level_3 := "res://Levels/Level3.tscn"
var next_level_path

var ready = true

func _ready():
	Transition.connect("transition_started", self, "_on_transition_started")
	Transition.connect("transition_completed", self, "_on_transition_completed")
	Transition.play_start_transition()
	AudioManager.play_reaper()
	set_player_position()
	
func set_player_position():
	match Events.current_level:
		1:
			path_follow.unit_offset = 0.5
		2 or 99:
			path_follow.unit_offset = 1
		3:
			path_follow.unit_offset = 0

func next_level_path() -> String:
	match Events.current_level:
		1:
			return level_1
		2:
			return level_2
		3:
			return level_3
		99:
			return level_2
	return ""
	
func _process(delta):
	yellow_pyramid_sprite.visible = Events.unlocked_level_2
	yellow_level_3.visible = Events.unlocked_level_3
	
	if Events.current_level == 1:
		if Input.is_action_just_pressed("ui_right") && Events.unlocked_level_2:
			ready = false
			animation_player.play("1-2")
			Events.current_level = 2
		if Input.is_action_just_pressed("ui_down") && Events.unlocked_level_3:
			ready = false
			animation_player.play("1-3")
			Events.current_level = 3
	if Events.current_level == 2 or Events.current_level == 99:
		if Input.is_action_just_pressed("ui_down"):
			ready = false
			animation_player.play_backwards("1-2")
			Events.current_level = 1
	if Events.current_level == 3:
		if Input.is_action_just_pressed("ui_right"):
			ready = false
			animation_player.play_backwards("1-3")
			Events.current_level = 1
	if Input.is_action_just_pressed("ui_jump"):
		start_selected_level()
		
func start_selected_level():
	if not ready: return
	AudioManager.play_random_checkpoint_sound()
	Transition.play_exit_transition()
	next_level_path = next_level_path()

func _on_transition_started():
	pass
	
func _on_transition_completed():
	if next_level_path == null: return
	get_tree().change_scene(next_level_path)
	
func _on_AnimationPlayer_animation_finished(anim_name):
	ready = true
