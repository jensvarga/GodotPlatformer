extends Node2D

onready var bg_sky := $"../ParallaxBackground/ParallaxLayer3/Sprite"

func _ready():
	bg_sky.position.y = 1066
