extends RayCast2D

onready var line := $Line2D
onready var tween := $Tween
onready var particles := $StartPointParticles
onready var collision_particles := $CollisionParticles
onready var beam_particles := $BeamParticles

var is_casting := false setget set_is_casting

func _ready():
	set_physics_process(false)
	line.points[1] = Vector2.ZERO

func _unhandled_input(event):
	if event is InputEventMouseButton:
		self.is_casting = event.pressed
		
func _physics_process(delta):
	var cast_point := cast_to
	force_raycast_update()
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
		collision_particles.global_rotation = get_collision_normal().angle()
		collision_particles.position = cast_point
		
	line.points[1] = cast_point
	beam_particles.position = cast_point * 0.5
	beam_particles.emission_rect_extents.x = cast_point.length() * 0.5

func set_is_casting(cast: bool) -> void:
	is_casting = cast
	
	particles.emitting = is_casting
	beam_particles.emitting = is_casting
	if is_casting:
		appear()
	else:
		collision_particles.emitting = false
		disappear()
		
	set_physics_process(is_casting)
	
func appear() -> void:
	tween.stop_all()
	tween.interpolate_property(line, "width", 0, 10.0, 0.2)
	tween.start()
	
func disappear() -> void:
	tween.stop_all()
	tween.interpolate_property(line, "width", 10, 0, 0.1)
	tween.start()
