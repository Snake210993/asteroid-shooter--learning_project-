extends Node

var player = preload("res://core/scenes/objects/Player_Ship.tscn")

var asteroids: Array[Node]
var points : int = 0



func reset_points() -> void:
	points = 0

func add_points(added_points : int) -> void:
	points += added_points
