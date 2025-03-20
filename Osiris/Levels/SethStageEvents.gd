extends Node2D

const FIRE_OF_THE_HORIZON := preload("res://Sound/Music/Original/Deflemask/FireOfTheHorizon.wav")
const SETH := preload("res://Seth.tscn")

onready var lightning_timer := $LightningTimer
onready var lightning_ap := $"../LightningAnimationPlayer"
onready var seth_start_pos := $SethStartPos

var spawned_seth = false

func _ready():
	randomize()
	Events.boss_hit_points = 12
	Events.has_power_crook = true
	Events.has_talaria = true
	lightning_timer.wait_time = rand_range(2, 10)
	lightning_timer.start()

func _on_LightningTimer_timeout():
	lightning_ap.play("Lighning")
	lightning_timer.wait_time = rand_range(4, 10)
	lightning_timer.start()

func play_thunder():
	AudioManager.play_random_thunder()

func spawn_seth():
	if not spawned_seth:
		spawned_seth = true
		var seth = SETH.instance()
		get_parent().call_deferred("add_child", seth)
		seth.position = seth_start_pos.global_position
		AudioManager.play_music(FIRE_OF_THE_HORIZON)
