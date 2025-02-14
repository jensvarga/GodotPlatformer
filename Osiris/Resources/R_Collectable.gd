tool
extends Resource
class_name CollectableResource

export(Texture) var texture
export(String) var ID

func collect_action():
	AudioManager.play_random_checkpoint_sound()
	Events.emit_signal("stage_cleared")
