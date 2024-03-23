extends Control

export (String, FILE, "*.tscn") var connecting_level_path = "res://Levels/OverworldLevel.tscn"

onready var logo := $AspectRatioContainer/Logo

var phi = (1 + sqrt(5)) / 2  
var growth_rate = phi / (phi * 60 * 60)

func _ready():
	VisualServer.set_default_clear_color(Color.black)
	Transition.skip_animation()

var initial_scale = Vector2(1, 1)
var target_scale = Vector2(1, 1)

var time_elapsed = 0.0

func _process(delta):
	time_elapsed += delta
	logo.scale += Vector2(growth_rate, growth_rate) * delta


func _on_Play_pressed():
	get_tree().change_scene(connecting_level_path)


func _on_Options_pressed():
	pass # Replace with function body.


func _on_Exit_pressed():
	get_tree().quit()
