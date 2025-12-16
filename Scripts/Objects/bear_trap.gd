extends Sprite2D
@onready var animator: AnimationPlayer = $Animator
@onready var detection_area: Area2D = $DetectionArea
func _ready() -> void:
	detection_area.connect("body_entered", _on_beartrap_entered)
func _on_beartrap_entered(body : Node2D) -> void:
	if body is Player:
		animator.call_deferred("play", "activate")
