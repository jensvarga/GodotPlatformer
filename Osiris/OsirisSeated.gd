extends Node2D

onready var tween := $Tween
onready var arm := $Sprite2

func _ready():
	tween.interpolate_property(arm, "rotation", arm.rotation + 45, arm.rotation - 45, 100, Tween.TRANS_SINE, tween.EASE_IN_OUT)
	tween.start()
