extends Node2D

@onready var ship: CharacterBody2D = $Ship
@onready var health: Node2D = $Ship/Health
@onready var screen_wrap: Node2D = $Ship/Screen_Wrap
@onready var invincibility_frames: Timer = $Ship/invincibility_frames

const SHIP_SHOOTING_SFX = "ship_shooting_sfx"
const SHIP_DEATH_SFX = "ship_death_explosion"
const SHIP_DAMAGED_SFX = "ship_damaged_sfx"

var ship_damaged_audio_control_token : String

@export var speed := 200
@export var turn_speed := 3.0

const TURN_LEFT = -1.0
const TURN_RIGHT = 1.0
const BREAKING_POWER := 2.0

const PROJECTILE = preload("res://_reusable/components/projectile.tscn")

signal player_died

var is_controllable: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var screen_size = get_viewport().size
	set_controllable(true)
	position.x = screen_size.x / 2
	position.y = screen_size.y / 2
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	_movement_logik(delta)
	
	if Input.is_action_just_pressed("Fire"): _fire_projectile()

func _fire_projectile() -> void:
	
	var projectile = PROJECTILE.instantiate()
	AudioManager.play_audio_stream(SHIP_SHOOTING_SFX, &"SFX")
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
	toggle_visibility(false)
	AudioManager.stop_looping_audio_stream(ship_damaged_audio_control_token)
	AudioManager.play_audio_stream(SHIP_DEATH_SFX, &"SFX")
	emit_signal("player_died")


func respawn() -> void:
	health._reset_health()
	ship.velocity = Vector2.ZERO
	ship.rotation = 0.0
	var screen_size = get_viewport().size
	ship.position = Vector2(screen_size.x * 0.5, screen_size.y * 0.5)
	set_controllable(true)
	toggle_visibility(true)
	set_collision_enabled(false)
	##enable invincible shader
	invincibility_frames.start()
	
func toggle_visibility(new_visibility) -> void:
	visible = new_visibility

func set_controllable(enable: bool) -> void:
	is_controllable = enable
	set_physics_process(enable)
	set_process_input(enable)
	set_process_unhandled_input(enable)
	set_collision_enabled(enable)
	
func set_collision_enabled(enable: bool) -> void:
	ship.set_collision_layer_value(1, enable)
	ship.set_collision_mask_value(3, enable)



func _on_invincibility_frames_timeout() -> void:
	set_collision_enabled(true)


func _on_is_damaged(in_health) -> void:
	ship_damaged_audio_control_token = AudioManager.play_looping_audio_stream(SHIP_DAMAGED_SFX, &"SFX")
