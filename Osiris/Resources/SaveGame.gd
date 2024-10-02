class_name SaveGame
extends Resource

# Global variables
export var death_counter := 0
export var collected_items := []
export var player_hit_points := 3

# Powerups
export var has_power_crook = false
export var lives = 3

# Bodyparts
export var has_left_hand = false
export var has_right_hand = false
export var has_pen15 = false
export var has_head = false

# Overworld values
export var player_overworld_position: Vector2 = Vector2(-103, -293)
export var unlocked_level_2 = false
export var unlocked_level_3 = false
export var ra_in_cave = false
export var ra_has_jumped = false

export var levels_cleared = {
	0: false,
	1: false,
	2: false,
	3: false,
	4: false,
	5: false
}
