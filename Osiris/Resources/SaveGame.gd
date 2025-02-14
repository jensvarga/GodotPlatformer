class_name SaveGame
extends Resource

# Global variables
export var death_counter := 0
export var player_hit_points := 3
export var max_player_hit_points := 3

# Powerups
export var has_power_crook = false
export var has_talaria = false
export var lives = 3

# Bodyparts
export var has_left_hand = false
export var has_right_hand = false
export var has_pen15 = false
export var has_head = false
export var has_left_foot = false
export var has_right_foot = false
export var has_torso = false

# Overworld values
export var player_overworld_position: Vector2 = Vector2(-103, -293)
export var ra_in_cave = false
export var ra_has_jumped = false
export var dark_overworld_water = false
export var granite_block_moved = false
export var hraf_position: Vector2 = Vector2(-297, 854)

# Collectables
export var lapis_ids := []

# Lighthpuse
export var best_lighthouse_counter := 0
