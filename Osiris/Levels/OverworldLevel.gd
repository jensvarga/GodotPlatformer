extends Node2D

export (Color) var bg_color = Color.deepskyblue

onready var water_tiles := $Tiles/WaterTiles
onready var player := $YSort/OverwoldPlayer
onready var anubis := $YSort/AnubisOverworld
onready var start_point := $StartPoint
onready var main_world_tiles := $Tiles
onready var overworld_blocks := $Tiles/Blocks
onready var subworld_tiles := $Subworld
onready var subworld_blocks := $Subworld/Blocks
onready var darkness := $SubworldTiles

onready var isis := $YSort/Isis

var anubis_offset = -20
var is_displaying_subworld = false
var subworld_npcs

func _ready():
	subworld_npcs = [isis]
	subworld_tiles.hide()
	main_world_tiles.show()
	water_tiles.show()
	overworld_blocks.hide()
	subworld_blocks.hide()
	subworld_blocks.set_collision_layer_bit(0, is_displaying_subworld)
	darkness.hide()
	Events.connect("player_died", self, "_on_player_died")
	Transition.connect("transition_started", self, "_on_transition_started")
	Transition.connect("transition_completed", self, "_on_transition_completed")
	VisualServer.set_default_clear_color(bg_color)
	AudioManager.play_overworld_music()
	Transition.play_start_transition()
	if Events.player_overworld_position == null:
		Events.player_overworld_position = start_point.position
	var player_position = Events.player_overworld_position
	player.position = player_position
	anubis.position = Vector2(player_position.x + anubis_offset, player_position.y - anubis_offset)
	show_subworld_npcs(is_displaying_subworld)
	
func toggle_subworld():
	if is_displaying_subworld:
		anubis.position = player.position
		subworld_tiles.hide()
		main_world_tiles.show()
		darkness.hide()
		is_displaying_subworld = false
	else:
		subworld_tiles.show()
		main_world_tiles.hide()
		darkness.show()
		is_displaying_subworld = true
	
	overworld_blocks.set_collision_layer_bit(0, !is_displaying_subworld)
	subworld_blocks.set_collision_layer_bit(0, is_displaying_subworld)
	show_subworld_npcs(is_displaying_subworld)
	
func show_subworld_npcs(should_show: bool):
	for npc in subworld_npcs:
		npc.visible = should_show
		npc.set_process_input(should_show)
		npc.set_process(should_show)
		npc.set_physics_process(should_show)

func _on_SubworldArea_body_entered(body):
	if body is OverworldPlayer:
		toggle_subworld()

func _on_SubworldArea_body_exited(body):
	if body is OverworldPlayer:
		toggle_subworld()
