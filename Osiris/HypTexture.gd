extends TextureRect

var folder_path = "res://Sprites/HypTextures/"

signal switch_texture

func _ready():
	connect("switch_texture", self, "_on_switch_texture")

func _on_switch_texture():
	set_hyp_texture()
	
func set_hyp_texture():
	if Events.family_friendly_mode:
		return
		
	var dir = Directory.new()
	if dir.open(folder_path) == OK:
		dir.list_dir_begin()
		var files = []
		var file_name = dir.get_next()
		
		while file_name != "":
			if file_name.ends_with(".png"):
				files.append(file_name)
			file_name = dir.get_next()
		
		dir.list_dir_end()
		
		if files.size() > 0:
			var random_index = randi() % files.size()
			var selected_file = files[random_index]
			var texture_path = folder_path + selected_file
			texture = load(texture_path)
