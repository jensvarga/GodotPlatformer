extends Node2D

onready var kill_timer := $KillTimer
onready var animation_player := $"../AnimationPlayer"

func _ready():
	Events.connect("boss_died", self, "_on_boss_died")
	Events.boss_hit_points = 12
	Events.has_power_crook = true
	Events.has_talaria = true
	
func _on_boss_died():
	kill_timer.start()

func _on_KillTimer_timeout():
	animation_player.play("LowerFoot")
	AudioManager.play_fanfare()
