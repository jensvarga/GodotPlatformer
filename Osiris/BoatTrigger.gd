extends Node2D

onready var root := $".."

var dialgue = [
	"Ah, so you come before me, Horus. I am Hraf-Haf, ferryman of the afterlife. My boat does not carry the unworthy",
	"I see you have gathered all seven Lapis Lazuli, proof of your worth",
	"Step aboard, Horus. The waters await, and we shall sail"
]

var island_dialgue = [
	"Come now, Horus. Let us sail back to the mainland"
]

var required_lapis = 7
var _index = 0
var mainland_pos := Vector2(-297, 854)
var island_position := Vector2(20, 1035)

var on_mainland: bool

func _ready():
	Events.connect("advance_dialouge_index", self, "_on_advance_dialouge_index")
	root.position = Events.hraf_position
	
	if root.global_position == mainland_pos:
		on_mainland = true
	else:
		on_mainland = false
		
	if Events.lapis_ids.size() >= required_lapis:
		if on_mainland:
			root.NPC_DIALOGUE = dialgue
		else: 
			root.NPC_DIALOGUE = island_dialgue
			
func _on_advance_dialouge_index():
	if Events.lapis_ids.size() >= required_lapis:
		_index += 1
	else:
		_index = 0
		
	if on_mainland:
		if _index == 2:
			AudioManager.fade_music()  
		if _index > 3:
			transport_player()
	elif not on_mainland:
		if _index == 1:
			AudioManager.fade_music()
		if _index > 1:
			transport_player()
	
func transport_player():
	if root.global_position == mainland_pos: # On main land
		Events.hraf_position = island_position
		Events.set_deferred("player_overworld_position", Vector2(island_position.x - 20, island_position.y))
		get_tree().call_deferred("reload_current_scene")
	else: # on island
		Events.hraf_position = mainland_pos
		Events.set_deferred("player_overworld_position", Vector2(mainland_pos.x - 20, mainland_pos.y))
		get_tree().call_deferred("reload_current_scene")
	
	


