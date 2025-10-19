extends Node2D

@onready var ship: CharacterBody2D = $Ship
@onready var health: Node2D = $Ship/Health


@export var speed := 500.0
var rotation_offset := PI/2 # set to PI/2 if your texture points up
var rotation_speed := 3.0 # rad/sec (~343°/s)

var acceleration := 5.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	_movement_logik(delta)
	if Input.is_action_just_pressed("Fire"): _fire_projectile()
	
func _fire_projectile() -> void:
	var PROJECTILE = load("res://reusable/components/projectile.tscn")
	var projectile = PROJECTILE.instantiate()

	add_child(projectile)
	projectile.shoot(ship.position, Vector2.UP.rotated(ship.rotation))
	

func _movement_logik(delta) -> void:

	var direction := Input.get_vector("Left","Right","Up","Down")
	var target_velocity := direction * speed
	
	_apply_rotation(direction, delta)

	ship.velocity = ship.velocity.lerp(target_velocity, clamp(acceleration * delta, 0.0, 1.0))
	ship.move_and_slide()	
	
func _apply_rotation(direction: Vector2, delta: float) -> void:
	if direction != Vector2.ZERO:
		var target_rotation = direction.angle() + rotation_offset
		var start_rotation = ship.rotation
		ship.rotation = lerp_angle(start_rotation, target_rotation, (rotation_speed  * delta))


func _on_health_zero_health_reached() -> void:
	queue_free()
