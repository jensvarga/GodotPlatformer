extends AnimatedSprite

onready var shader_material = material as ShaderMaterial

func _ready():
	shader_material.set_shader_param("active", false)
