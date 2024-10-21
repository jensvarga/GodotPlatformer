extends Node

onready var darkwater_trigger_1 := $TriggerDarkWater/CollisionShape2D
onready var darkwater_trigger_2 := $TriggerDarkWater/CollisionShape2D2
onready var animation_player := $"../AnimationPlayer"

onready var water_tile := $"../Tiles/WaterTiles/Water"
const SONG := preload("res://Sound/Music/Original/Deflemask/DreamOff.wav")

func _ready():
	if Events.dark_overworld_water:
		water_tile.material.set_shader_param("darken_amount", 1)
		darkwater_trigger_2.set_deferred("disabled", false)
		darkwater_trigger_1.set_deferred("disabled", true)
		AudioManager.call_deferred("stop_music")
	else:
		water_tile.material.set_shader_param("darken_amount", 0)
		darkwater_trigger_2.set_deferred("disabled", true)
		darkwater_trigger_1.set_deferred("disabled", false)

func toggle_water_fade():
	if Events.dark_overworld_water:
		Events.dark_overworld_water = false
		animation_player.play_backwards("FadeOcean")
		AudioManager.fade_in_music(SONG)
		darkwater_trigger_2.set_deferred("disabled", true)
		darkwater_trigger_1.set_deferred("disabled", false)
	else:
		Events.dark_overworld_water = true
		animation_player.play("FadeOcean")
		AudioManager.fade_music()
		darkwater_trigger_2.set_deferred("disabled", false)
		darkwater_trigger_1.set_deferred("disabled", true)
	
func _on_TriggerDarkWater_body_entered(body):
	if body is OverworldPlayer:
		toggle_water_fade()
