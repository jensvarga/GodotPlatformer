extends Area2D

export (bool) var triggered = false

onready var boss: = $"../Path2D/PathFollow2D/Aphopis"
onready var animator: = $"../Path2D/AnimationPlayer"
onready var boss_timer: = $Timer
onready var cloud1: = $"../RedCloud"
onready var cloud2: = $"../RedCloud2"
onready var cloud3: = $"../RedCloud3"
onready var cloud4: = $"../RedCloud4"
onready var cloud5: = $"../RedCloud5"
onready var music_timer: = $MusicTimer
onready var camera: = $"../PlayerRoot/Anchor/Camera2D"
onready var boss_path: = $"../Path2D/PathFollow2D"
onready var collision: = $CollisionShape2D

func _ready():
	Events.connect("checkpoint_reached", self, "_on_checkpoint_reached")
	if Events.check_point_reached:
		collision.set_deferred("disabled", true)
		camera.limit_right = 500
		load_from_checkpoint()

func load_from_checkpoint():
	cloud1.queue_free()
	cloud2.queue_free()
	cloud3.queue_free()
	cloud4.queue_free()
	cloud5.queue_free()
	boss_path.unit_offset = 0.9

func _on_BossTrigger_body_entered(body):
	if triggered: return
	if body is Player and not Events.check_point_reached:
		Events.emit_signal("checkpoint_reached")
		boss_entrance()
		triggered = true
		collision.set_deferred("disabled", true)
		
func boss_entrance():
	AudioManager.play_aphopis_entrance_sound()
	#music_timer.start()
	AudioManager.play_boss_music()
	boss_timer.start()
	if animator.has_animation("Entrance"):
		animator.play("Entrance")
		boss.show_sprites()
	else:
		print("Animation not found: ", "Entrance")

func _on_Timer_timeout():
	boss.enter_idle()
	cloud1.fade_cloud()
	cloud2.fade_cloud()
	cloud3.fade_cloud()
	cloud4.fade_cloud()
	cloud5.fade_cloud()


func _on_MusicTimer_timeout():
	AudioManager.play_boss_music()
	
func _on_checkpoint_reached():
	camera.limit_right = 500
