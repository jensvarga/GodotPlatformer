extends Node2D

onready var sprite := $Sprite
var collected = false

export (NodePath) var info_screen_path
export (String) var title = "TALARIA"
export (String) var description = "in air to double jump" 
export (String) var key_binding = "ui_jump"
export (Texture) var image = null
export (Texture) var description_image = null

const INFO_SCREEN := preload("res://PowerUpInfoScreen.tscn")

func _ready():
	if Events.has_talaria:
		collected = true
		sprite.hide()
		$Area2D/CollisionShape2D.set_deferred("disabled", true)

func _on_Area2D_body_entered(body):
	if body is Player and not collected:
		AudioManager.play_power_up()
		Events.emit_signal("pick_up_talaria")
		var info = get_node(info_screen_path)
		info.initialize(title, description, key_binding, image, description_image)
		info.show()
		collected = true
		sprite.hide()
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
