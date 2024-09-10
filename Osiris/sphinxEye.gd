extends Sprite

var player: Player = null

func _ready():
	Events.connect("player_died", self, "_on_player_died")

func _physics_process(delta):
	if player == null:
		player = Events.player
	else:
		var direction = player.global_position - global_position	
		var angle = atan2(direction.y, direction.x)
		rotation = angle

func _on_player_died():
	player = null
