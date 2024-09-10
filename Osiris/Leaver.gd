extends Area2D

export (Array, NodePath) var spinning_wheels = []

onready var sprite := $AnimatedSprite

func _ready():
	sprite.animation = "On"

func switch_direction():
	AudioManager.play_click()
	if sprite.animation == "On":
		sprite.animation = "Off"
	else:
		sprite.animation = "On"
		
	for wheel_path in spinning_wheels:
		var wheel = get_node(wheel_path)
		if wheel is SpinningWheel:
				wheel.switch_direction()

func _on_Leaver_area_entered(area):
		switch_direction()
