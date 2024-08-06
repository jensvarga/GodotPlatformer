extends StaticBody2D

var Seti = preload("res://Seti.tscn")

onready var sprite := $AnimatedSprite
onready var explode_timer := $ExplodeTimer
onready var animation_player := $"../AnimationPlayer"
onready var victory_delay_timer := $"../VictoryDelayTimer"

onready var part1 := $part1
onready var part2 := $part2
onready var part3 := $part3
onready var part4 := $part4
onready var part5 := $part5

onready var bat_particles := [
	$"../BatCollisions/CollisionShape2D3/BatParticles1",
	$"../BatCollisions/CollisionShape2D/BatParticles2",
	$"../BatCollisions/CollisionShape2D/BatParticles1",
	$"../BatCollisions/CollisionShape2D3/BatParticles1",
	$"../BatCollisions/CollisionShape2D3/BatParticles2",
	$"../BatCollisions/CollisionShape2D2/BatParticles1",
	$"../BatCollisions/CollisionShape2D2/BatParticles2",
	$"../BatCollisions/CollisionShape2D4/BatParticles1",
	$"../BatCollisions/CollisionShape2D5/BatParticles1",
	$"../BatCollisions/CollisionShape2D6/BatParticles1",
	$"../BatCollisions/CollisionShape2D7/BatParticles1"
]

var previous_frame = 0

# Bat events 
onready var bat_event_timer := $"../BatEventTimer"
onready var boss_dead = false

func _ready():
	Events.connect("boss_died", self, "_on_boss_died")
	Events.connect("damage_boss", self, "_on_damage_boss")
	sprite.animation = "default"
	part1.gravity_scale = 0
	part1.hide()
	part2.gravity_scale = 0
	part2.hide()
	part3.gravity_scale = 0
	part3.hide()
	part4.gravity_scale = 0
	part4.hide()
	part5.gravity_scale = 0
	part5.hide()
	start_crack()
	
func _process(delta):
	if previous_frame < sprite.frame:
		AudioManager.play_boom()
		
	previous_frame = sprite.frame
	
	
func start_crack():
	explode_timer.start()
	sprite.animation = "Explode"
	
func _on_ExplodeTimer_timeout():
	CameraShaker.add_trauma(0.6)
	AudioManager.play_set_entrance()
	AudioManager.play_boom()
	AudioManager.play_seti_music()
	var seti_instance = Seti.instance()
	seti_instance.position = position
	get_parent().add_child(seti_instance)
	
	sprite.hide()
	
	part1.show()
	part2.show()
	part3.show()
	part4.show()
	part5.show()
	
	part1.gravity_scale = 1
	part1.apply_central_impulse(Vector2(10, -150))
	part1.apply_torque_impulse(rand_range(-360, 360))
	
	part2.gravity_scale = 1
	part2.apply_central_impulse(Vector2(100, -50))
	part2.apply_torque_impulse(rand_range(-360, 360))
	
	part3.gravity_scale = 1
	part3.apply_central_impulse(Vector2(-100, -50))
	part3.apply_torque_impulse(rand_range(-360, 360))
	
	part4.gravity_scale = 1
	part4.apply_central_impulse(Vector2(100, -50))
	part4.apply_torque_impulse(rand_range(-360, 360))
	
	part5.gravity_scale = 1
	part5.apply_central_impulse(Vector2(-100, -50))
	part5.apply_torque_impulse(rand_range(-360, 360))

func _on_boss_died():
	animation_player.stop()
	boss_dead = true
	reset_particles()
	victory_delay_timer.start()
	
func _on_damage_boss():
	if Events.boss_hit_points == 6:
		randomize()
		bat_event_timer.wait_time = rand_range(4, 7)
		bat_event_timer.start()
		
func play_bat_pattern():
		randomize()
		match int(rand_range(1, 4 + 1)):
			1:
				animation_player.play("BatPattern1")
				AudioManager.play_bat_swarm()
			2: 
				animation_player.play_backwards("BatPattern1")
				AudioManager.play_bat_swarm()
			3:
				animation_player.play("BatPattern2")
				AudioManager.play_bat_swarm()
			4:
				animation_player.play("BatPattern3")
				AudioManager.play_bat_swarm()
				
func reset_particles():
	for particles in bat_particles:
		if particles is CPUParticles2D:
			particles.lifetime = 1.0
			particles.emitting = false

func _on_BatEventTimer_timeout():
	if boss_dead:
		return
	play_bat_pattern()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "BatPattern1" or anim_name == "BatPattern2" or anim_name == "BatPattern3":
		bat_event_timer.wait_time = rand_range(4, 7)
		bat_event_timer.start()
		
func _on_BatCollisions_body_entered(body):
	if boss_dead:
		return
	if body is Player:
		body.hurt()

func _on_VictoryDelayTimer_timeout():
	AudioManager.play_fanfare()
	animation_player.play("LowerHand")
