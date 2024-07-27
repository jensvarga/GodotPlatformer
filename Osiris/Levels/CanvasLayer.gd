extends CanvasLayer

onready var level := $".."
onready var boss_life := $BossLife

onready var ankh1 := $Ankh1
onready var ankh2 := $Ankh2
onready var ankh3 := $Ankh3

onready var boss_ankh1 := $BossLife/BossAnkh1
onready var boss_ankh2 := $BossLife/BossAnkh2
onready var boss_ankh3 := $BossLife/BossAnkh3
onready var boss_ankh4 := $BossLife/BossAnkh4
onready var boss_ankh5 := $BossLife/BossAnkh5
onready var boss_ankh6 := $BossLife/BossAnkh6

func _ready():
	Events.connect("player_take_damage", self, "_on_player_take_damage")
	Events.connect("pick_up_ankh", self, "_on_pick_up_ankh")
	Events.connect("damage_boss", self, "_on_damage_boss")
	
	update_ankhs()
	update_boss_ankhs()
	
	if not level.boss_level:
		boss_life.hide()
	
func _on_player_take_damage():
	update_ankhs()
	
func _on_damage_boss():
	update_boss_ankhs()
	
func _on_pick_up_ankh():
	update_ankhs()

func update_ankhs():
	match Events.player_hit_points:
		0:
			ankh1.animation = "Empty"
			ankh2.animation = "Empty"
			ankh3.animation = "Empty"
		1:
			ankh1.animation = "Full"
			ankh2.animation = "Empty"
			ankh3.animation = "Empty"
		2:
			ankh1.animation = "Full"
			ankh2.animation = "Full"
			ankh3.animation = "Empty"
		3:
			ankh1.animation = "Full"
			ankh2.animation = "Full"
			ankh3.animation = "Full"

func update_boss_ankhs():
	match Events.boss_hit_points:
		0:
			boss_ankh1.animation = "Empty"
			boss_ankh2.animation = "Empty"
			boss_ankh3.animation = "Empty"
			boss_ankh4.animation = "Empty"
			boss_ankh5.animation = "Empty"
			boss_ankh6.animation = "Empty"
		1:
			boss_ankh1.animation = "Full"
			boss_ankh2.animation = "Empty"
			boss_ankh3.animation = "Empty"
			boss_ankh4.animation = "Empty"
			boss_ankh5.animation = "Empty"
			boss_ankh6.animation = "Empty"
		2:
			boss_ankh1.animation = "Full"
			boss_ankh2.animation = "Full"
			boss_ankh3.animation = "Empty"
			boss_ankh4.animation = "Empty"
			boss_ankh5.animation = "Empty"
			boss_ankh6.animation = "Empty"
		3:
			boss_ankh1.animation = "Full"
			boss_ankh2.animation = "Full"
			boss_ankh3.animation = "Full"
			boss_ankh4.animation = "Empty"
			boss_ankh5.animation = "Empty"
			boss_ankh6.animation = "Empty"
		4:
			boss_ankh1.animation = "Full"
			boss_ankh2.animation = "Full"
			boss_ankh3.animation = "Full"
			boss_ankh4.animation = "Full"
			boss_ankh5.animation = "Empty"
			boss_ankh6.animation = "Empty"
		5:
			boss_ankh1.animation = "Full"
			boss_ankh2.animation = "Full"
			boss_ankh3.animation = "Full"
			boss_ankh4.animation = "Full"
			boss_ankh5.animation = "Full"
			boss_ankh6.animation = "Empty"
		6:
			boss_ankh1.animation = "Full"
			boss_ankh2.animation = "Full"
			boss_ankh3.animation = "Full"
			boss_ankh4.animation = "Full"
			boss_ankh5.animation = "Full"
			boss_ankh6.animation = "Full"
