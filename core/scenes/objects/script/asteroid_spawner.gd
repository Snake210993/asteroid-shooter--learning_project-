extends Node

@onready var screen_size = get_viewport().size
@onready var player_ship: Node2D = $"../PlayerShip"
@onready var asteroid_spawn_timer: Timer = $asteroid_spawn_timer

const ASTEROID_LARGE = preload("res://core/scenes/objects/large_asteroid.tscn")
const ASTEROID_SMALL = preload("res://core/scenes/objects/small_asteroid.tscn")


const MAX_TORQUE : int = 100
const MIN_TORQUE : int = -100

const MAX_THRUST : int = 50
const MIN_THRUST : int = 20

const MAX_DEVIATION : int = 100
const MIN_DEVIATION : int = -100

const MAX_ROTATION : int = 360

const ASTEROID_STARTING_AMOUNT : int = 6
const MAXIMUM_ASTEROID_COUNT : int = 7

var left_spawning_rectangle : Rect2i
var right_spawning_rectangle : Rect2i
var top_spawning_rectangle : Rect2i
var bottom_spawning_rectangle : Rect2i

var rectangle_array : Array[Rect2i]



var is_spawning_enabled : bool = false



func _ready() -> void:
	left_spawning_rectangle = Rect2i(-100, 0, 100, screen_size.y)
	rectangle_array.push_back(left_spawning_rectangle)
	right_spawning_rectangle = Rect2i(screen_size.x, 0, 100, screen_size.y)
	rectangle_array.push_back(right_spawning_rectangle)
	bottom_spawning_rectangle = Rect2i(0, screen_size.y, screen_size.x, 100)
	rectangle_array.push_back(bottom_spawning_rectangle)
	top_spawning_rectangle = Rect2i(0, 0, screen_size.x, -100)
	rectangle_array.push_back(top_spawning_rectangle)
	

func _on_asteroid_spawn_timer_timeout() -> void:
	_spawn_random_asteroid()

func _process(_delta: float) -> void:
	var current_asteroid_count: int = asteroid_collection.asteroids.size()
	
	if current_asteroid_count < ASTEROID_STARTING_AMOUNT and is_spawning_enabled == false:
		asteroid_spawn_timer.start()
		is_spawning_enabled = true
	if asteroid_collection.asteroids.size() > MAXIMUM_ASTEROID_COUNT and is_spawning_enabled == true:
		asteroid_spawn_timer.stop()
		is_spawning_enabled = false

func _spawn_random_asteroid() -> void:
	
	##instantiate new asteroid
	var new_asteroid = ASTEROID_LARGE.instantiate()
	
	##pick a spawning rectangle
	var spawning_rectangle = rectangle_array.get(randi_range(0, (rectangle_array.size()-1)))
	
	##calculate coordinate ranges
	var min_x: int = spawning_rectangle.position.x
	var max_x: int = spawning_rectangle.position.x + spawning_rectangle.size.x
	var min_y: int = spawning_rectangle.position.y
	var max_y: int = spawning_rectangle.position.y + spawning_rectangle.size.y
	
	##get random spawn
	var pos_x = randi_range(min_x, max_x)
	var pos_y = randi_range(min_y, max_y)
	
	
	
	new_asteroid.position = Vector2(pos_x,pos_y)
	var new_thrust_vector = player_ship.position - new_asteroid.position
	## modulate new_thrust_vector that asteroids not always fly straight at the player
	var added_thrust = randi_range(MIN_THRUST, MAX_THRUST)
	var added_thrust_vector = Vector2(added_thrust,added_thrust)
	new_asteroid.thrust = new_thrust_vector.normalized() * added_thrust_vector
	new_asteroid.torque = randi_range(MIN_TORQUE, MAX_TORQUE)
	new_asteroid.has_fractured_spawn_small_asteroids.connect(Callable(self, "_has_fractured_spawn_small_asteroids"))
	add_child(new_asteroid)
	
	asteroid_collection.asteroids.push_back(new_asteroid)
	
func _spawn_small_asteroid(position, velocity):
		var new_small_asteroid = ASTEROID_SMALL.instantiate()
		new_small_asteroid.position = position
		var deviation = randi_range(MIN_DEVIATION, MAX_DEVIATION)
		var deviation_vector = Vector2(deviation,deviation)
		new_small_asteroid.thrust = velocity + deviation_vector
		new_small_asteroid.torque = randi_range(MIN_TORQUE, MAX_TORQUE)
		new_small_asteroid.rotation = randi_range(0, MAX_ROTATION)
		add_child(new_small_asteroid)
		asteroid_collection.asteroids.push_back(new_small_asteroid)
	
func _has_fractured_spawn_small_asteroids(amount, position, velocity) -> void:

	for n in amount:
		_spawn_small_asteroid(position, velocity)
