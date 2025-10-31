extends RigidBody2D

class_name asteroid

@onready var screen_wrap: Node2D = $Screen_Wrap
@onready var screen_size = get_viewport().size

const MAX_FRACTURE_AMOUNT = 3

signal has_fractured_spawn_small_asteroids

var fracture_amount

var has_entered_viewport: bool = false

var thrust : Vector2
var torque : float
var damage = 50


func _process(_delta: float) -> void:
	# Check if the asteroid is inside the visible screen
	var is_inside_viewport: bool = (
	global_position.x >= 0 
	and global_position.x <= screen_size.x
	and global_position.y >= 0
	and global_position.y <= screen_size.y
	)
	# If it enters the viewport for the first time, record that state
	if is_inside_viewport and (has_entered_viewport == false):
		has_entered_viewport = true


func _ready() -> void:
	screen_wrap.IS_SCREEN_WRAPPING = false
	linear_velocity = thrust
	add_constant_torque(torque)
	fracture_amount = randi_range(0, MAX_FRACTURE_AMOUNT)

func _physics_process(_delta: float) -> void:
	if (has_entered_viewport):
		screen_wrap.IS_SCREEN_WRAPPING = true
	screen_wrap.screen_wrap()

func _on_collision(body: Node) -> void:
	if body.has_node("Health"):
		var Health = body.get_node("Health")
		Health.take_damage(damage)
		

func _on_health_zero_health_reached() -> void:
	has_fractured_spawn_small_asteroids.emit(fracture_amount, global_position, linear_velocity)
	asteroid_collection.asteroids.erase(self)
	asteroid_collection.points += 40
	print("large asteroid died - replace with sound")
	queue_free()
