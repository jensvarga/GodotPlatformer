extends Node2D

export (Color) var sky_color = Color.deepskyblue
const MUSIC = preload("res://Sound/Music/Original/Deflemask/PyrricVictory.wav")

export (String, FILE, "*.tscn") var next_scene_path

onready var throne_room_ap := $ThroneRoomAnimationPlayer
onready var desert_ap := $DesertAnimationPlayer
onready var credits_ap := $CreditsAnimationPlayer
onready var exit_timer := $ExitTimer

func _input(event):
	if event.is_action_released("ui_cancel"):
		AudioManager.fade_music()
		exit_timer.start()

func _ready():
	VisualServer.set_default_clear_color(sky_color)
	throne_room_ap.play("FadeInThroneRoom")
	AudioManager.play_music(MUSIC)

func fade_in_desert():
	desert_ap.play("FadeInDesert")

func roll_credits():
	credits_ap.play("RollCredits")

func exit():
	AudioManager.fade_music()
	exit_timer.start()

func _on_ExitTimer_timeout():
	get_tree().change_scene(next_scene_path)
