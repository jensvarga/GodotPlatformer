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

func _ready():
	pass

func load_from_checkpoint():
	pass

func _on_BossTrigger_body_entered(body):
	if triggered: return
	if body is Player and not Events.check_point_reached:
		Events.emit_signal("checkpoint_reached")
		boss_entrance()
		
func boss_entrance():
	AudioManager.play_aphopis_entrance_sound()
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
