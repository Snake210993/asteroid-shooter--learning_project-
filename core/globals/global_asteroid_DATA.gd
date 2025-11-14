extends Node

var player = preload("res://core/scenes/objects/Player_Ship.tscn")

var asteroids: Array[Node]
var points : int = 0



func reset_points() -> void:
	points = 0

func add_points(added_points : int) -> void:
	points += added_points


func remove_self_from_asteroids(to_be_removed) -> void:
	asteroids.erase(to_be_removed)

func add_to_asteroids(to_be_added) -> void:
	asteroids.push_back(to_be_added)
