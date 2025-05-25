extends Node

var path = "user://data.json"
var settings_path = "user://settings.json"

var default_data = {
	"death_counter": 0,
	"has_power_crook": false,
	"has_talaria": false,
	"lives": 3,
	"has_left_hand": false,
	"has_right_hand": false,
	"has_pen15": false,
	"has_head": false,
	"has_left_foot": false,
	"has_right_foot": false,
	"has_torso": false,
	"player_overworld_position": Vector2(-103, -293),
	"ra_in_cave": false,
	"ra_has_jumped": false,
	"dark_overworld_water": false,
	"granite_block_moved": false,
	"hraf_position": Vector2(-297, 854),
	"lapis_ids": [],
	"best_lighthouse_counter": 0,
	"has_ressurected_osiris": false
}

var default_settings = {
	"family_friendly_mode": true,
	"fullscreen": true
}

var data = {}
var settings = {}

func load_game():
	print("Load game path: ", path)
	var file = File.new()
	if not file.file_exists(path):
		reset_data()
		parse_data_to_event()
		return
	
	file.open(path, file.READ)
	var text = file.get_as_text()
	data = parse_json(text)
	parse_data_to_event()
	file.close()

func load_settings():
	print("Load settings path: ", settings_path)
	var file = File.new()
	if not file.file_exists(settings_path):
		reset_settings()
		Events.family_friendly_mode = settings["family_friendly_mode"]
		Events.fullscreen = settings["fullscreen"]
		return
	
	file.open(settings_path, file.READ)
	var text = file.get_as_text()
	settings = parse_json(text)
	Events.family_friendly_mode = settings["family_friendly_mode"]
	Events.fullscreen = settings["fullscreen"]
	Events.emit_signal("updated_fullscreen")
	file.close()

func reset_settings():
	settings = default_settings.duplicate(true)

func save_game():
	print("Save game path: ", path)
	var file = File.new()
	file.open(path, file.WRITE)
	parse_event_to_data()
	file.store_line(to_json(data))
	file .close()

func save_settings():
	print("Save settings path: ", settings_path)
	var file = File.new()
	file.open(settings_path, file.WRITE)
	settings["family_friendly_mode"] = Events.family_friendly_mode
	settings["fullscreen"] = Events.fullscreen
	file.store_line(to_json(settings))
	file .close()

func reset_data():
	data = default_data.duplicate(true)

func save_exists() -> bool:
	var file = File.new()
	return file.file_exists(path)

func erase_save():
	if save_exists():
		var dir = Directory.new()
		dir.remove(path)

func parse_data_to_event():
	Events.death_counter = data["death_counter"]
	Events.has_power_crook = data["has_power_crook"]
	Events.has_talaria = data["has_talaria"]
	Events.lives = data["lives"]
	Events.has_left_hand = data["has_left_hand"]
	Events.has_right_hand = data["has_right_hand"]
	Events.has_pen15 = data["has_pen15"]
	Events.has_head = data["has_head"]
	Events.has_left_foot = data["has_left_foot"]
	Events.has_right_foot = data["has_right_foot"]
	Events.has_torso = data["has_torso"]
	Events.player_overworld_position = Vector2(data["player_overworld_position"]["x"], data["player_overworld_position"]["y"])
	Events.ra_in_cave = data["ra_in_cave"]
	Events.ra_has_jumped = data["ra_has_jumped"]
	Events.dark_overworld_water = data["dark_overworld_water"]
	Events.granite_block_moved = data["granite_block_moved"]
	Events.lapis_ids = data["lapis_ids"]
	Events.hraf_position = Vector2(data["hraf_position"]["x"], data["hraf_position"]["y"])
	Events.best_lighthouse_counter = data["best_lighthouse_counter"]
	Events.has_ressurected_osiris = data["has_ressurected_osiris"]

func parse_event_to_data():
	data["death_counter"] = Events.death_counter
	data["has_power_crook"] = Events.has_power_crook
	data["has_talaria"] = Events.has_talaria
	data["lives"] = Events.lives
	data["has_left_hand"] = Events.has_left_hand
	data["has_right_hand"] = Events.has_right_hand
	data["has_pen15"] = Events.has_pen15
	data["has_head"] = Events.has_head
	data["has_left_foot"] = Events.has_left_foot
	data["has_right_foot"] = Events.has_right_foot
	data["has_torso"] = Events.has_torso
	data["player_overworld_position"] = {"x": Events.player_overworld_position.x, "y": Events.player_overworld_position.y}
	data["ra_in_cave"] = Events.ra_in_cave
	data["ra_has_jumped"] = Events.ra_has_jumped
	data["dark_overworld_water"] = Events.dark_overworld_water
	data["granite_block_moved"] = Events.granite_block_moved
	data["lapis_ids"] = Events.lapis_ids
	data["hraf_position"] = {"x": Events.hraf_position.x, "y": Events.hraf_position.y}
	data["best_lighthouse_counter"] = Events.best_lighthouse_counter
	data["has_ressurected_osiris"] = Events.has_ressurected_osiris

