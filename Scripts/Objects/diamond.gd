extends Area2D

@onready var animator: AnimationPlayer = $Animator

func _ready() -> void:
	connect("body_entered", _on_orb_entered)
	connect("body_exited", _on_orb_exited)
func _on_orb_entered(body: Node2D) -> void:
	if body is Player:
		body.reflect(global_position)
		SignalManager.emit_signal("camera_shake")
func _on_orb_exited(body: Node2D) -> void:
	if body is Player:
		pass
