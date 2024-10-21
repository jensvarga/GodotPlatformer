extends Control

onready var head := $HeadTexture
onready var torso := $TorsoTexture
onready var right_hand := $RightHandTexture
onready var left_hand := $LeftHandTexture
onready var pen15 := $Pen15Texture
onready var right_foot := $RightFootTexture
onready var left_foot := $LeftFootTexture
onready var eggplant := $EggplantTexture

func _ready():
	Events.connect("stage_cleared", self, "_on_stage_cleared")
	call_deferred("_update_body_parts")

func _on_stage_cleared():
	call_deferred("_update_body_parts")
	
func _update_body_parts():
	if Events.has_head:
		head.show()
	else:
		head.hide()
	if Events.has_torso:
		torso.show()
	else:
		torso.hide()
	if Events.has_right_hand:
		right_hand.show()
	else:
		right_hand.hide()
	if Events.has_left_hand:
		left_hand.show()
	else:
		left_hand.hide()
	if Events.has_pen15:
		if Events.family_friendly_mode:
			eggplant.show()
			pen15.hide()
		else:
			pen15.show()
			eggplant.hide()
	else:
		pen15.hide()
		eggplant.hide()
	if Events.has_right_foot:
		right_foot.show()
	else:
		right_foot.hide()
	if Events.has_left_foot:
		left_foot.show()
	else:
		left_foot.hide()
