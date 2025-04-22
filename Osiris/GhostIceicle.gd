extends Sprite

onready var tween := $Tween

func _ready():
	tween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.7, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()

func _on_Tween_tween_completed(object, key):
	call_deferred("queue_free")
