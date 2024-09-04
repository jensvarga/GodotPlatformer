extends Node2D

onready var tween := $Tween
onready var timer := $Timer
onready var hand := $RightHand

func _ready():
	Events.connect("boss_died", self, "_on_boss_died")
	
func _on_boss_died():
	timer.start()

func _on_Timer_timeout():
	tween.interpolate_property(hand, "position:y", hand.position.y, hand.position.y + 220, 5, tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()
	AudioManager.play_fanfare()
