class_name ModifiedCamera extends Camera2D

@export var player : Player
@export var randomStrength: float = 8.0
@export var shakeFade: float = 5.0

var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0
var room_zones : Array = []
var active_zone : Area2D

@onready var screen_size: Vector2 = get_viewport_rect().size

func _ready() -> void:
	add_to_group("camera")
	SignalManager.connect("camera_shake", _apply_shake)
	set_screen_position()
	await get_tree().process_frame
	position_smoothing_enabled = true
	position_smoothing_speed = 7.0

func _process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shakeFade * delta)
		offset = randomOffset()
	if !room_zones.is_empty():
		active_zone = room_zones.front()
		global_position = active_zone.global_position
func _apply_shake():
	shake_strength = randomStrength
func set_screen_position() -> void:
	var player_position = player.global_position
	var x = floor(player_position.x / screen_size.x) * screen_size.x + screen_size.x / 2
	var y = floor(player_position.y / screen_size.y) * screen_size.y + screen_size.y / 2
	global_position = Vector2(x,y)
func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength),rng.randf_range(-shake_strength, shake_strength))
