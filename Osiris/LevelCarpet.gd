extends Node2D

export (int) var level_index = 0
export (String, FILE, "*.tscn") var connecting_level_path

onready var sprite := $Sprite

var red_carpet_texture = preload("res://Sprites/red_carpet.png")
var yellow_carpet_texture = preload("res://Sprites/yellow_carpet.png")

var is_player_on_carpet = false
var offset = 5
var pressed_button = false

func _ready():
	Transition.connect("transition_completed", self, "_on_transition_completed")
	
	if Events.levels_cleared[level_index] == true:
		sprite.texture = yellow_carpet_texture
	else:
		sprite.texture = red_carpet_texture
		
func _input(event):
	if is_player_on_carpet and event.is_action_released("ui_jump"):
		pressed_button = true
		start_selected_level()

func start_selected_level():
	AudioManager.play_random_checkpoint_sound()
	Transition.play_exit_transition()
	
func _on_transition_completed():
	if not pressed_button: return
	if connecting_level_path == null: return
	if not is_player_on_carpet: return
	Events.player_overworld_position = Vector2(global_position.x + offset, global_position.y + offset)
	get_tree().change_scene(connecting_level_path)

func _on_Area2D_body_entered(body):
	if body is OverworldPlayer:
		is_player_on_carpet = true

func _on_Area2D_body_exited(body):
	if body is OverworldPlayer:
		is_player_on_carpet = false