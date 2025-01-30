extends Sprite

var intact_texture = preload("res://Sprites/Overworld/lib_of_ax.png")
var burned_texture = preload("res://Sprites/Overworld/lib_of_ax_burned.png")

func _ready():
	update_texture()

func update_texture():
	if Events.library_burned:
		texture = burned_texture
	else:
		texture = intact_texture
