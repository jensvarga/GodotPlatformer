extends AnimatedSprite

onready var animation_player := $AnimationPlayer

func _ready():
	frame = 0
	play()

func _on_DyingBaht_animation_finished():
	animation_player.play("Dissolve")

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
