extends CanvasLayer

onready var level := $".."
onready var boss_life := $BossLife
export (int) var max_boss_hp = 6 

onready var ankh1 := $Ankh1
onready var ankh2 := $Ankh2
onready var ankh3 := $Ankh3

onready var boss_ankh1 := $BossLife/BossAnkh1
onready var boss_ankh2 := $BossLife/BossAnkh2
onready var boss_ankh3 := $BossLife/BossAnkh3
onready var boss_ankh4 := $BossLife/BossAnkh4
onready var boss_ankh5 := $BossLife/BossAnkh5
onready var boss_ankh6 := $BossLife/BossAnkh6

onready var power_crook := $PowerCrook
onready var talaria := $Talaria
onready var lapis_count := $LapisCounter
onready var lapis_sprite := $Lapis

func _ready():
	Events.connect("player_take_damage", self, "_on_player_take_damage")
	Events.connect("pick_up_ankh", self, "_on_pick_up_ankh")
	Events.connect("damage_boss", self, "_on_damage_boss")
	Events.connect("pick_up_power_crook", self, "_on_pick_up_power_crook")
	Events.connect("pick_up_talaria", self, "on_pick_up_talaria")
	Events.connect("gained_life", self, "_on_gained_life")
	Events.connect("player_spawned", self, "_on_player_spawned")
	Events.connect("update_lapis_count", self, "_on_update_lapis_count")
	
	if Events.has_power_crook:
		power_crook.show()
	else:
		power_crook.hide()
	
	if Events.has_talaria:
		talaria.show()
	else:
		talaria.hide()
	
	if level.boss_level:
		Events.boss_hit_points = max_boss_hp
		call_deferred("update_boss_ankhs")
	else:
		boss_life.hide()
	
	$LifeCounter.text = " x " + (Events.lives as String)
	call_deferred("update_ankhs")
	update_lapis_count()

func update_lapis_count():
	var elements = Events.lapis_ids.size()
	if elements <= 0:
		lapis_sprite.hide()
		lapis_count.text = ""
	else:
		lapis_sprite.show()
		lapis_count.text = " x " + (elements as String)
	
func _on_gained_life():
	$LifeCounter.text = " x " + (Events.lives as String)
	
func _on_player_take_damage():
	call_deferred("update_ankhs")
	
func _on_damage_boss():
	call_deferred("update_boss_ankhs")
	
func _on_pick_up_ankh():
	call_deferred("update_ankhs")
	
func _on_pick_up_power_crook():
	power_crook.show()

func on_pick_up_talaria():
	talaria.show()

func _on_player_spawned():
	call_deferred("update_ankhs")

func _on_update_lapis_count():
	update_lapis_count()

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
			boss_ankh1.animation = "Half"
			boss_ankh2.animation = "Empty"
			boss_ankh3.animation = "Empty"
			boss_ankh4.animation = "Empty"
			boss_ankh5.animation = "Empty"
			boss_ankh6.animation = "Empty"
		2:
			boss_ankh1.animation = "Full"
			boss_ankh2.animation = "Empty"
			boss_ankh3.animation = "Empty"
			boss_ankh4.animation = "Empty"
			boss_ankh5.animation = "Empty"
			boss_ankh6.animation = "Empty"
		3:
			boss_ankh1.animation = "Full"
			boss_ankh2.animation = "Half"
			boss_ankh3.animation = "Empty"
			boss_ankh4.animation = "Empty"
			boss_ankh5.animation = "Empty"
			boss_ankh6.animation = "Empty"
		4:
			boss_ankh1.animation = "Full"
			boss_ankh2.animation = "Full"
			boss_ankh3.animation = "Empty"
			boss_ankh4.animation = "Empty"
			boss_ankh5.animation = "Empty"
			boss_ankh6.animation = "Empty"
		5:
			boss_ankh1.animation = "Full"
			boss_ankh2.animation = "Full"
			boss_ankh3.animation = "Half"
			boss_ankh4.animation = "Empty"
			boss_ankh5.animation = "Empty"
			boss_ankh6.animation = "Empty"
		6:
			boss_ankh1.animation = "Full"
			boss_ankh2.animation = "Full"
			boss_ankh3.animation = "Full"
			boss_ankh4.animation = "Empty"
			boss_ankh5.animation = "Empty"
			boss_ankh6.animation = "Empty"
		7:
			boss_ankh1.animation = "Full"
			boss_ankh2.animation = "Full"
			boss_ankh3.animation = "Full"
			boss_ankh4.animation = "Half"
			boss_ankh5.animation = "Empty"
			boss_ankh6.animation = "Empty"
		8:
			boss_ankh1.animation = "Full"
			boss_ankh2.animation = "Full"
			boss_ankh3.animation = "Full"
			boss_ankh4.animation = "Full"
			boss_ankh5.animation = "Empty"
			boss_ankh6.animation = "Empty"
		9:
			boss_ankh1.animation = "Full"
			boss_ankh2.animation = "Full"
			boss_ankh3.animation = "Full"
			boss_ankh4.animation = "Full"
			boss_ankh5.animation = "Half"
			boss_ankh6.animation = "Empty"
		10:
			boss_ankh1.animation = "Full"
			boss_ankh2.animation = "Full"
			boss_ankh3.animation = "Full"
			boss_ankh4.animation = "Full"
			boss_ankh5.animation = "Full"
			boss_ankh6.animation = "Empty"
		11:
			boss_ankh1.animation = "Full"
			boss_ankh2.animation = "Full"
			boss_ankh3.animation = "Full"
			boss_ankh4.animation = "Full"
			boss_ankh5.animation = "Full"
			boss_ankh6.animation = "Half"
		12:
			boss_ankh1.animation = "Full"
			boss_ankh2.animation = "Full"
			boss_ankh3.animation = "Full"
			boss_ankh4.animation = "Full"
			boss_ankh5.animation = "Full"
			boss_ankh6.animation = "Full"
