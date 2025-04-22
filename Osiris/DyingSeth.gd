extends AnimatedSprite

const SPLASH := preload("res://GreenSplash.tscn")
const PARTICLES := preload("res://SethDeathParticles.tscn")
const SCREAM := preload("res://Sound/FX/MISC/Seth_die.wav")

onready var particles := $CPUParticles2D

func _ready():
	animation = "default"
	$AnimationPlayer.play("Default")
	AudioManager.play_sound(SCREAM)

func _on_Timer_timeout():
	$DestroyTimer.start()
	animation = "Tear"

func _on_DestroyTimer_timeout():
	queue_free()

func thunder():
	AudioManager.play_random_thunder()
	summon_particles()

func explode():
	summon_particles()
	AudioManager.play_random_thunder()
	AudioManager.play_boom()
	var splash := SPLASH.instance()
	splash.call_deferred("set_blue")
	get_parent().call_deferred("add_child", splash)
	splash.set_deferred("position", $Position2D.global_position)
	CameraShaker.add_trauma(0.4)

func summon_particles():
	var parts = PARTICLES.instance()
	get_parent().call_deferred("add_child", parts)
	parts.position = $Position2D.global_position
