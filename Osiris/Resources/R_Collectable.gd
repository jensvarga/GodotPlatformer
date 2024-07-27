tool
extends Resource
class_name CollectableResource

export(Texture) var texture
export(String) var ID

func collect_action():
	Events.collected_items.append(ID)
	AudioManager.play_random_checkpoint_sound()
	print("Collected", ID)
	Events.emit_signal("stage_cleared")
