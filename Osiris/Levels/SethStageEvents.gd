extends Node2D

const FIRE_OF_THE_HORIZON := preload("res://Sound/Music/Original/Deflemask/FireOfTheHorizon.wav")
const SETH := preload("res://Seth.tscn")
const PLATFORM := preload("res://MovingPlatformSethStage.tscn")
const ICEICLE := preload("res://Iceicle.tscn")


export (bool) var spawn_platforms = false
export (float) var platform_spawn_rate = 1
export (bool) var spawn_iceicles = false
export (float) var iceicle_spawn_rate = 1.1
export (String, FILE, "*.tscn") var previous_level_path = "res://Levels/LightHouseLevels/LighthouseSummit.tscn"
export (String, FILE, "*.tscn") var next_scene_path

var thunder_on = true

onready var lightning_timer := $LightningTimer
onready var platform_timer := $PlatformTimer
onready var iceicle_timer := $IceicleTimer
onready var lightning_ap := $"../LightningAnimationPlayer"
onready var seth_start_pos := $SethStartPos
onready var end_timer := $EndStageTimer

var spawned_seth = false

func _ready():
	randomize()
	Events.connect("damage_boss", self, "_on_damage_boss")
	Events.connect("boss_died", self, "_on_boss_died")
	Transition.connect("pixelation_completed", self , "_on_pixelation_completed")
	Events.boss_hit_points = 1
	Events.has_power_crook = true
	Events.has_talaria = true
	lightning_timer.wait_time = rand_range(2, 10)
	lightning_timer.start()
	platform_timer.wait_time = platform_spawn_rate
	platform_timer.start()
	iceicle_timer.wait_time = iceicle_spawn_rate
	iceicle_timer.start()

func _on_LightningTimer_timeout():
	if not thunder_on:
		return
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

func _on_PlatformTimer_timeout():
	if not spawn_platforms:
		return
	var platform := PLATFORM.instance()
	if rand_range(0, 3) < 1:
		platform.global_position = Vector2(clamp(Events.player.global_position.x, -192, 192), 150)
	else:
		platform.global_position = Vector2(rand_range(-192, 192), 150)
	platform.speed = rand_range(40, 100)
	get_parent().call_deferred("add_child", platform)

func _on_damage_boss():
	if Events.boss_hit_points == 6:
		spawn_platforms = true
	if Events.boss_hit_points == 4:
		spawn_iceicles = true
		
func _on_boss_died():
	spawn_platforms = false
	spawn_iceicles = false
	thunder_on = false
	end_timer.start()

func _on_pixelation_completed():
	AudioManager.stop_music()
	Events.lighthouse_counter = 42
	#Events.save_game_data()
	Events.check_point_reached = true
	get_tree().call_deferred("change_scene", previous_level_path)
	#get_tree().change_scene(previous_level_path)

func _on_IceicleTimer_timeout():
	if not spawn_iceicles:
		return
	var iceicle := ICEICLE.instance()
	if rand_range(0, 3) < 1:
		iceicle.global_position = Vector2(clamp(Events.player.global_position.x, -192, 192), -200)
	else:
		iceicle.global_position = Vector2(rand_range(-192, 192), -200)
	iceicle.speed = rand_range(70, 150)
	get_parent().call_deferred("add_child", iceicle)

func _on_EndStageTimer_timeout():
	get_tree().call_deferred("change_scene", next_scene_path)
