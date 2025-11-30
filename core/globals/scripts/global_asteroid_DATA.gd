extends Node




const MAX_HIGHSCORES : int = 5

var asteroids: Array[Node]
var points : int = 0

var array_highscores_2d: Array = [[2480, "Deborah"], [1245, "Simon"], [250, "Peter"], [2200, "Christoph"], [10, "Oliver"]]

#SETTINGS FLAGS
var is_self_damage_enabled : bool = false

func _ready() -> void:
	load_game()

func reset_points() -> void:
	points = 0

func add_points(added_points : int) -> void:
	points += added_points


func remove_self_from_asteroids(to_be_removed) -> void:
	asteroids.erase(to_be_removed)

func add_to_asteroids(to_be_added) -> void:
	asteroids.push_back(to_be_added)

func sort_highscores() -> void:
	array_highscores_2d.sort()

func save_game() -> void:
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	save_file.store_var(array_highscores_2d)
	save_file.close()

func load_game() -> void:
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	array_highscores_2d = save_file.get_var()
	save_file.close()
