extends Path2D

export (float) var speed := 1
export (float) var delay := 0

onready var path_follow := $PathFollow2D
onready var tween := $Tween
onready var delay_timer := $DelayTimer

func _ready():
	if delay > 0:
		delay_timer.wait_time = delay
	delay_timer.start()

func restart():
	tween.interpolate_property(path_follow, "unit_offset", 0, 1, speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
	
func _on_Tween_tween_all_completed():
	delay_timer.start()

func _on_DelayTimer_timeout():
	restart()
