extends Sprite

const CROOK := preload("res://Crook.tscn")

onready var spawn_timer := $Timer

var active = false

func _on_VisibilityNotifier2D_screen_entered():
	active = true
	spawn_timer.wait_time = rand_range(2, 4)
	spawn_timer.start()

func _on_VisibilityNotifier2D_screen_exited():
	active = false

func _on_Timer_timeout():
	if active:
		spawn_crook()
		
		spawn_timer.wait_time = rand_range(2, 4)
		spawn_timer.start()

func spawn_crook():
	var crook := CROOK.instance()
	crook.position = global_position
	get_parent().call_deferred("add_child", crook)
