extends Node2D

const BAHT := preload("res://Baht.tscn")
const FLY_SLIME := preload("res://FlySlime.tscn")

onready var furthest_hypno_texture := $"../ParallaxBackground/Sprite4"
onready var middle_hypno_texture := $"../ParallaxBackground/Sprite2"
onready var nearest_hypno_texture := $"../Sprite3"
onready var road_node := $"../HypTextures/Roads"
onready var win_timer := $WinTimer
onready var pen15 := $Pen15

onready var tween := $Tween
onready var slimes_node := $Slimes
onready var hyp_tex := $"../HypTextures/Roads/TextureRect"

var baht = null
var first_time = true
var slime_count = 0
var flashing = false
var hide = false

func _ready():
	Events.has_power_crook = true
	Events.has_talaria = true
	Events.boss_hit_points = 12
	Events.connect("boss_died", self, "_on_boss_died")
	hide_secrets()

func _process(delta):
	peek_through_the_pines()

func fade_in_texture(texture: Sprite):
	texture.modulate.a = 0
	
	tween.interpolate_property(
		texture, "modulate:a",
		0,
		1,
		1.0,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	
	tween.start()

func fade_out_texture(texture: Sprite):
	texture.modulate.a = 1
	
	tween.interpolate_property(
		texture, "modulate:a",
		1,
		0,
		1.0,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	
	tween.start()

func spawn_baht():
	baht = BAHT.instance()
	get_parent().call_deferred("add_child", baht)
	baht.call_deferred("set_event_node", self)
	if first_time:
		baht.position = Vector2.ZERO
		first_time = false
	else:
		var pos = Events.player.global_position
		var height = rand_range(-75, 0)
		baht.position = Vector2(pos.x, height)
		baht.set_deferred("vunerable", true)
		
	baht.connect("flash", self, "_on_flash")
	
func _on_StartTimer_timeout():
	AudioManager.play_forced_pleasure()
	fade_in_texture(furthest_hypno_texture)
	
	yield(get_tree().create_timer(1.0), "timeout")
	fade_out_texture(furthest_hypno_texture)
	fade_in_texture(middle_hypno_texture)

	yield(get_tree().create_timer(1.0), "timeout")
	fade_out_texture(middle_hypno_texture)
	fade_in_texture(nearest_hypno_texture)
	
	yield(get_tree().create_timer(1.0), "timeout")
	spawn_baht()
	fade_out_texture(nearest_hypno_texture)

func hypno_attack():
	if baht.state == baht.State.DEAD: return
	fade_in_texture(furthest_hypno_texture)
	
	yield(get_tree().create_timer(.25), "timeout")
	fade_out_texture(furthest_hypno_texture)
	fade_in_texture(middle_hypno_texture)

	yield(get_tree().create_timer(.25), "timeout")
	fade_out_texture(middle_hypno_texture)
	fade_in_texture(nearest_hypno_texture)
	
	yield(get_tree().create_timer(.25), "timeout")
	
	baht.call_deferred("queue_free")
	call_deferred("spawn_baht")
	
	fade_out_texture(nearest_hypno_texture)

func reset_attack():
	if baht.state == baht.State.DEAD: return
	fade_in_texture(furthest_hypno_texture)
	
	yield(get_tree().create_timer(.25), "timeout")
	fade_out_texture(furthest_hypno_texture)
	fade_in_texture(middle_hypno_texture)

	yield(get_tree().create_timer(.5), "timeout")
	fade_out_texture(middle_hypno_texture)
	suck_slimes()

func suck_slimes():
	if baht.state == baht.State.DEAD: return
	var slimes = slimes_node.get_children()
	for slime in slimes:
		var fs = FLY_SLIME.instance()
		get_parent().call_deferred("add_child", fs)
		fs.call_deferred("set_target", baht)
		fs.position = slime.global_position
		slime.queue_free()

func hide_secrets():
	var roads = road_node.get_children()
	for road in roads:
		road.hide()
		
	flashing = false
	hide = false

func peek_through_the_pines():
	if flashing:
		hyp_tex.emit_signal("switch_texture")
		if hide:
			call_deferred("hide_secrets")
		hide = true

func _on_flash():
	if Events.family_friendly_mode:
		return
	flashing = true
	var roads = road_node.get_children()
	var random_index = randi() % roads.size()
	var random_road = roads[random_index]
	random_road.show()

func _on_boss_died():
	win_timer.start()

func _on_WinTimer_timeout():
	AudioManager.play_fanfare()
	tween.interpolate_property(pen15, "position:y", pen15.position.y, pen15.position.y + 250, 5, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()
