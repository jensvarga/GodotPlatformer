extends Node2D

export (Color) var bg_color = Color.deepskyblue

onready var water_tiles := $Tiles/WaterTiles
onready var collider_tiles := $Tiles/Blocks

func _ready():
	water_tiles.show()
	collider_tiles.hide()
	Events.connect("player_died", self, "_on_player_died")
	Transition.connect("transition_started", self, "_on_transition_started")
	Transition.connect("transition_completed", self, "_on_transition_completed")
	VisualServer.set_default_clear_color(bg_color)
	AudioManager.play_reaper()
	Transition.play_start_transition()
