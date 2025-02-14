extends Node2D

var overworld_path = "res://Levels/OverworldLevel.tscn"

var player_on_door := false

onready var bg_sky := $"../ParallaxBackground/ParallaxLayer3/Sprite"
onready var cloud_bg := $"../ParallaxBackground/ParallaxLayer/Sprite"

func _ready():
	Transition.connect("pixelation_completed", self, "_on_pixelation_completed")
	Events.has_talaria = true
	Events.has_power_crook = true
	bg_sky.global_position.y += Events.lighthouse_counter * 21
	if Events.lighthouse_counter >= 30:
		cloud_bg.hide()

# Return to overworld when die
func _on_pixelation_completed():
	AudioManager.stop_music()
	Events.lighthouse_counter = 0
	Events.completed_levels = []
	Events.save_game_data()
	get_tree().change_scene(overworld_path)

func _input(event):
	if event.is_action_pressed("ui_up") and player_on_door:
		_load_next_room()

func _load_next_room():
	AudioManager.play_random_checkpoint_sound()
	Events.lighthouse_counter += 1
	Events.update_best_lighthouse_count()
	Events.play_random_lighthouse_level()
		
func _on_Area2D_body_entered(body):
	if body is Player:
		player_on_door = true

func _on_Area2D_body_exited(body):
	if body is Player:
		player_on_door = false
