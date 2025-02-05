extends CanvasLayer

onready var label := $Label

func _ready():
	Events.connect("update_overworld_level_label", self, "_on_update_overworld_level_label")
	label.text = Events.overworld_level_label

func _on_update_overworld_level_label():
	label.text = Events.overworld_level_label
