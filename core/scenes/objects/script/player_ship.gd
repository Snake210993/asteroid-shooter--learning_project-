extends Node2D

@onready var ship: CharacterBody2D = $Ship
@onready var health: Node2D = $Ship/Health
@onready var screen_wrap: Node2D = $Ship/Screen_Wrap
@export var speed := 200
@export var turn_speed := 3.0

const TURN_LEFT = -1.0
const TURN_RIGHT = 1.0
const BREAKING_POWER := 2.0

const PROJECTILE = preload("res://reusable/components/projectile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var screen_size = get_viewport().size
	position.x = screen_size.x / 2
	position.y = screen_size.y / 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	_movement_logik(delta)
	##add sounds
	if Input.is_action_just_pressed("Fire"): _fire_projectile()

func _fire_projectile() -> void:
	
	var projectile = PROJECTILE.instantiate()
	##add sound
	add_child(projectile)
	projectile.shoot(ship.position, Vector2.UP.rotated(ship.rotation))
	
	

func _movement_logik(delta) -> void:
	
	var direction
	if Input.is_action_pressed("Left"): 
		direction = TURN_LEFT * turn_speed
	elif Input.is_action_pressed("Right"):
		direction =  TURN_RIGHT * turn_speed
	else: direction = 0
	
	ship.rotation += direction * delta
	
	
	if Input.is_action_pressed("Up"):
		var thrust_direction
		thrust_direction = Vector2.UP.rotated(ship.rotation)
		ship.velocity += thrust_direction * speed * delta
	else:
		ship.velocity = ship.velocity.lerp(Vector2.ZERO, clamp(BREAKING_POWER * delta, 0.0, 1.0))
	
	ship.move_and_slide() ## move and slide needs to be after any changed are made to velocity
	screen_wrap.screen_wrap()
	
func _on_health_zero_health_reached() -> void:
	queue_free()
	print("You Died")
	
func take_damage(received_damage) -> void:
	health.take_damage(received_damage)
