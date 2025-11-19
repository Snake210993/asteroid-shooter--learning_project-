extends Node

@onready var screen_size = get_viewport().size
@onready var asteroid_spawn_timer: Timer = $asteroid_spawn_timer

const ASTEROID_LARGE = preload("res://core/scenes/objects/large_asteroid.tscn")
const ASTEROID_SMALL = preload("res://core/scenes/objects/small_asteroid.tscn")

@onready var asteroid_root_node: Node = $".."


const MAX_TORQUE : int = 3000
const MIN_TORQUE : int = -3000

const MAX_THRUST : int = 50
const MIN_THRUST : int = 20

const MAX_DEVIATION : int = 70
const MIN_DEVIATION : int = -70

const MAX_ROTATION : int = 360

const ASTEROID_STARTING_AMOUNT : int = 6
const MAXIMUM_ASTEROID_COUNT : int = 50

const FRACTURE_INCREMENT : int = 3
const TIMER_DECREMENT : float = 1.0


var left_spawning_rectangle : Rect2i
var right_spawning_rectangle : Rect2i
var top_spawning_rectangle : Rect2i
var bottom_spawning_rectangle : Rect2i

var rectangle_array : Array[Rect2i]

var max_asteroid_fractures = 5

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
	var current_asteroid_count: int = GLOBAL_DATA.asteroids.size()
	
	if current_asteroid_count < ASTEROID_STARTING_AMOUNT and is_spawning_enabled == false:
		asteroid_spawn_timer.start()
		is_spawning_enabled = true
	if GLOBAL_DATA.asteroids.size() > MAXIMUM_ASTEROID_COUNT and is_spawning_enabled == true:
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
	var calculated_target_position = Vector2(screen_size.x/2, randi_range(100, screen_size.y - 100))
	var new_thrust_vector = calculated_target_position - new_asteroid.position
	## modulate new_thrust_vector that asteroids not always fly straight at the player
	var added_thrust = randi_range(MIN_THRUST, MAX_THRUST)
	var added_thrust_vector = Vector2(added_thrust,added_thrust)
	new_asteroid.thrust = new_thrust_vector.normalized() * added_thrust_vector
	new_asteroid.torque = randi_range(MIN_TORQUE, MAX_TORQUE)
	new_asteroid.rotation = randi_range(0, MAX_ROTATION)
	new_asteroid.has_fractured_spawn_small_asteroids.connect(Callable(self, "_has_fractured_spawn_small_asteroids"))
	new_asteroid.receive_points.connect(Callable(asteroid_root_node, "_on_receive_points"))
	new_asteroid.edit_fracture_amount(max_asteroid_fractures)
	add_child(new_asteroid)
	
	GLOBAL_DATA.add_to_asteroids(new_asteroid)
	
func _spawn_small_asteroid(position, velocity):
		var new_small_asteroid := ASTEROID_SMALL.instantiate()
		new_small_asteroid.position = position
		var deviation_x = randi_range(MIN_DEVIATION, MAX_DEVIATION)
		var deviation_y = randi_range(MIN_DEVIATION, MAX_DEVIATION)
		var deviation_vector = Vector2(deviation_x,deviation_y)
		new_small_asteroid.thrust = velocity + deviation_vector
		new_small_asteroid.torque = randi_range(MIN_TORQUE, MAX_TORQUE)
		new_small_asteroid.rotation = randi_range(0, MAX_ROTATION)
		new_small_asteroid.receive_points.connect(Callable(asteroid_root_node, "_on_receive_points"))
		call_deferred("add_child", new_small_asteroid)
		GLOBAL_DATA.add_to_asteroids(new_small_asteroid)

func _has_fractured_spawn_small_asteroids(amount, position, velocity) -> void:
	for n in amount:
		_spawn_small_asteroid(position, velocity)

func clean_asteroids() -> void:
	for n in GLOBAL_DATA.asteroids:
		n.queue_free()
	GLOBAL_DATA.asteroids.clear()


func _on_clean_asteroids() -> void:
	clean_asteroids()


func _on_increase_difficulty() -> void:
	asteroid_spawn_timer.wait_time -= TIMER_DECREMENT
	max_asteroid_fractures += FRACTURE_INCREMENT
	print("new fracture amount " + str(max_asteroid_fractures))
	print("new wait time" + str(asteroid_spawn_timer.wait_time))
