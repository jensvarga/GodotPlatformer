extends Node2D

class_name PlayerHurtParticles

onready var particles := $CPUParticles2D
onready var clouds := $Clouds
onready var ankh := $Ankh

func _ready():
	emit()

func emit():
	particles.restart()
	clouds.restart()
	ankh.restart()
