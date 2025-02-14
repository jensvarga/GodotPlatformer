extends Node2D

const LIGHTHOUSE_SONG := preload("res://Sound/Music/Original/Deflemask/CrystalLine.wav")

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
onready var lighthouse := $YSort/LightHouse
onready var camera := $YSort/OverwoldPlayer/Camera2D

onready var hathor := $YSort/Hathor
onready var isis := $YSort/Isis
onready var ra2 := $YSort/RA2
onready var ra := $YSort/RA
onready var sekhmet := $YSort/Sekhmet
onready var hapi := $YSort/Hapi
onready var ihy := $YSort/Ihy

onready var thot2 := $YSort/Thoth2
onready var lighthouse_door := $LightHouseDoor
onready var fountain := $YSort/Fountain

onready var hathor_pos_1 := $HathorPositions/Position2D
onready var hathor_pos_2 := $HathorPositions/Position2D2

var anubis_offset = -20
var is_displaying_subworld = false
var subworld_npcs

func _ready():
	if Events.ra_in_cave:
		subworld_npcs = [isis, ra2, sekhmet, hapi, ihy]
	else:
		subworld_npcs = [isis]
	if Events.ra_in_cave or Events.ra_has_jumped:
		ra.queue_free()
		
	subworld_tiles.hide()
	main_world_tiles.show()
	water_tiles.show()
	overworld_blocks.hide()
	subworld_blocks.hide()
	subworld_blocks.set_collision_layer_bit(0, is_displaying_subworld)
	darkness.hide()
	Transition.connect("transition_started", self, "_on_transition_started")
	Transition.connect("transition_completed", self, "_on_transition_completed")
	VisualServer.set_default_clear_color(bg_color)
	Events.lighthouse_level = false
	camera.smoothing_enabled = false # Enable with timer to avoid drag at start
	
	var bottom_left = Vector2(-77, 1100)
	var top_right = Vector2(368, 644)
	if Events.player_overworld_position != null:
		if Events.player_overworld_position.x >= bottom_left.x and \
		   Events.player_overworld_position.x <= top_right.x and \
		   Events.player_overworld_position.y >= top_right.y and \
		   Events.player_overworld_position.y <= bottom_left.y: # Within island rect
			AudioManager.play_music(LIGHTHOUSE_SONG)
		else:
			AudioManager.play_overworld_music()
	else:
		AudioManager.play_overworld_music()
		
	if Events.player_overworld_position == null:
		Events.player_overworld_position = start_point.position
	var player_position = Events.player_overworld_position
	player.position = player_position
	anubis.position = Vector2(player_position.x + anubis_offset, player_position.y - anubis_offset)
	show_subworld_npcs(is_displaying_subworld)
	fountain.hide()
	place_hathor()
	Transition.play_start_transition()
	
func toggle_subworld():
	if is_displaying_subworld:
		anubis.position = player.position
		subworld_tiles.hide()
		main_world_tiles.show()
		darkness.hide()
		is_displaying_subworld = false
		lighthouse.show()
		thot2.show()
		fountain.hide()
	else:
		subworld_tiles.show()
		main_world_tiles.hide()
		darkness.show()
		lighthouse.hide()
		thot2.hide()
		fountain.show()
		is_displaying_subworld = true
	
	overworld_blocks.set_collision_layer_bit(0, !is_displaying_subworld)
	subworld_blocks.set_collision_layer_bit(0, is_displaying_subworld)
	show_subworld_npcs(is_displaying_subworld)
	
func show_subworld_npcs(should_show: bool):
	for npc in subworld_npcs:
		if not npc.HIDDEN:
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

func _on_transition_started():
	pass

func _on_transition_completed():
	pass

func _on_LightHouseDoor_body_entered(body):
	if body is OverworldPlayer:
		toggle_subworld()

func _on_LightHouseDoor_body_exited(body):
	if body is OverworldPlayer:
		toggle_subworld()

func _on_CameraSmoothingTimer_timeout():
	camera.smoothing_enabled = true

func place_hathor():
	if Events.has_all_bodyparts():
		var dialouge = [
			"Horus, you have done it! You have gathered all the scattered pieces of your father",
			"Now, return them to Isis, that she may perform the sacred rites of rebirth",
			"And thus, Osiris shall rise once more"
		]
		hathor.NPC_DIALOGUE = dialouge
		hathor.facing = hathor.FACING.UP
		hathor.default_facing()
		
		var player_pos = Events.player_overworld_position
		if player_pos.distance_to(hathor_pos_1.global_position) < player_pos.distance_to(hathor_pos_2.global_position):
			hathor.position = hathor_pos_1.global_position
		else:
			hathor.position = hathor_pos_2.global_position
	
