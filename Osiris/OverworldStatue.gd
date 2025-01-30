extends StaticBody2D

export (Texture) var texture = preload("res://Sprites/Overworld/statue_OW_1.png")
onready var sprite := $Sprite

func _ready():
	sprite.texture = texture
