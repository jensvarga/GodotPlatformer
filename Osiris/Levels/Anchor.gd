extends Position2D

var player
onready var camera: = $Camera2D
onready var noise = OpenSimplexNoise.new()
var noise_y = 0

export var decay = 0.8  # How quickly the shaking stops [0, 1].
export var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.
export var max_roll = 0.1  # Maximum rotation in radians (use sparingly)
var trauma = 0.0  # Current shake strength.
var trauma_power = 3  # Trauma exponent. Use [2, 3].


func _ready():
	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2
	
func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)
	
func _process(delta):
	if player == null: return
	var target = player.global_position
	var target_pos_x = int(lerp(global_position.x, target.x, 0.3 * 60 * delta))
	var target_pos_y = int(lerp(global_position.y, target.y, 0.3 * 60 * delta))
	global_position = Vector2(target_pos_x, target_pos_y)
	
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()

func shake():
	var amount = pow(trauma, trauma_power)
	noise_y += 1
	camera.rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	camera.offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
	camera.offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)

func connect_player(play):
	player = play
