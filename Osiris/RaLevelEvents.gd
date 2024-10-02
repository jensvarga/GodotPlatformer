extends Node2D

onready var bottom := $"../Bottom"
onready var scrolling_bg := $"../ParallaxBackground"
onready var start_timer := $StartTimer
onready var price_timer := $PrizeTimer
onready var tween := $Tween
onready var head := $"../Head"

var scroll_bottom = false
var stopped = false

func _ready():
	Events.connect("player_spawned", self, "_on_player_spawned")
	Events.connect("boss_died", self, "_on_boss_died")
	Events.boss_hit_points = 12

func _physics_process(delta):
	if scroll_bottom:
		bottom.position.y += scrolling_bg.scroll_speed * delta
	if bottom.position.y <= 110 and not stopped:
		stopped = true
		scrolling_bg.stopped = true
		scroll_bottom = false
		if Events.player != null:
			Events.player.enter_move()
	
func _on_player_spawned():
	var player = Events.player
	if player.has_method("enter_flying") and player:
		Events.player.call_deferred("enter_flying")

func _on_boss_died():
	start_timer.start()
	AudioManager.fade_music()

func _on_StartTimer_timeout():
	scroll_bottom = true
	Events.player.enter_move()
	price_timer.start()

func _on_PrizeTimer_timeout():
	AudioManager.play_fanfare()
	tween.interpolate_property(head, "position", head.position, Vector2(head.position.x, 30), 5, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()
