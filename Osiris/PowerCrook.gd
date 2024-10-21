extends Node2D

onready var sprite := $Sprite
var collected = false

export (NodePath) var info_screen_path
export (String) var title = "CROOK"
export (String) var description = "to shoot magical projectile" 
export (String) var key_binding = "PrimaryAction"
export (Texture) var image = null
export (Texture) var description_image = null

func _ready():
	if Events.has_power_crook:
		collected = true
		sprite.hide()
		$Area2D/CollisionShape2D.set_deferred("disabled", true)

func _on_Area2D_body_entered(body):
	if body is Player and not collected:
		AudioManager.play_power_up()
		Events.emit_signal("pick_up_power_crook")
		var info = get_node(info_screen_path)
		info.initialize(title, description, key_binding, image, description_image)
		info.show()
		collected = true
		sprite.hide()
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
