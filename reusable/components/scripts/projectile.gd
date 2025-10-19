extends Node2D

var direction : Vector2
var speed : float = 400.0


func _process(delta: float) -> void:
	position += direction * speed * delta

func shoot(new_position : Vector2, new_direction : Vector2) -> void:
	position = new_position
	direction = new_direction
