class_name RoomArea extends Area2D

@export var respawn_point : Node2D
@onready var respawn_position = respawn_point.global_position

func _ready() -> void:
	connect("body_entered", _on_room_entered)
func _on_room_entered(body : Node2D) -> void:
	if body is Player:
		body.set_room(self)
