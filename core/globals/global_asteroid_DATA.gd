extends Node


const MAX_HIGHSCORES : int = 5

var asteroids: Array[Node]
var points : int = 0
var highscores : Array[int] = [0,0,0,0,0]


#SETTINGS FLAGS
var is_self_damage_enabled : bool = false


func commit_to_highscore(new_points : int) -> void:
	highscores.push_back(new_points)
	if highscores.size() > MAX_HIGHSCORES:
		highscores.sort()
		highscores.remove_at(0)

func reset_points() -> void:
	points = 0

func add_points(added_points : int) -> void:
	points += added_points


func remove_self_from_asteroids(to_be_removed) -> void:
	asteroids.erase(to_be_removed)

func add_to_asteroids(to_be_added) -> void:
	asteroids.push_back(to_be_added)
