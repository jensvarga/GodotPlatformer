extends RigidBody2D

const GHOST := preload("res://GhostPlatform.tscn")
export (float) var speed = 50

func _ready():
	Events.connect("boss_died", self, "_on_boss_died")

func _physics_process(delta):
	global_position.y -= speed * delta

func _on_Timer_timeout():
	var ghost := GHOST.instance()
	get_parent().call_deferred("add_child", ghost)
	ghost.rotation = rotation
	ghost.position = global_position

func _on_VisibilityNotifier2D_screen_exited():
	call_deferred("queue_free")

func _on_boss_died():
	call_deferred("queue_free")
