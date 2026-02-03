extends CanvasLayer

@onready var player_state_label: Label = $PlayerStateLabel
@export var player : Player
func _process(delta: float) -> void:
	player_state_label.text = player.get_state()
