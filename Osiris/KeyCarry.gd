extends CarryItem
class_name Key

onready var particles := $KeyParticles

func use():
	AudioManager.play_key_sound()
	particles.emitting = true
