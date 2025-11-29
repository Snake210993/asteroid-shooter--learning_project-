extends Node2D

@onready var ship: CharacterBody2D = $Ship
@onready var health: Node2D = $Ship/Health
@onready var screen_wrap: Node2D = $Ship/Screen_Wrap
@onready var invincibility_frames: Timer = $Ship/invincibility_frames
@onready var damaged_particles: GPUParticles2D = $Ship/damaged_particles
@onready var thruster_particles: GPUParticles2D = $Ship/ThrusterParticles

@export var ship_explosion_scene : PackedScene

const SHIP_SHOOTING_SFX = "ship_shooting_sfx"
const SHIP_DEATH_SFX = "ship_death_explosion"
const SHIP_DAMAGED_SFX = "ship_damaged_sfx"
const SHIP_ENGINE_RUNNING_SFX = "ship_engine_sfx"

var ship_damaged_audio_control_token : String
var engine_audio_control_token : String

@export var speed := 200
@export var turn_speed := 3.0

const TURN_LEFT = -1.0
const TURN_RIGHT = 1.0
const BREAKING_POWER := 2.0

const PROJECTILE = preload("res://_reusable/components/projectile.tscn")

signal player_died

var screen_size : Vector2

var is_controllable: bool = true
var engine_is_running : bool = false 
var ship_is_damaged : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_screen_size()
	set_controllable(true)
	_update_position()
	get_viewport().size_changed.connect(_update_screen_size)

func _update_position() -> void:
	position.x = screen_size.x / 2
	position.y = screen_size.y / 2
func _update_screen_size() -> void:
	var visible_rectangle : Rect2 = get_viewport().get_visible_rect()
	screen_size = visible_rectangle.size
	_update_position()

func spawn_explosion(in_explosion_scene : PackedScene) -> void:
	var detached_root: Node = get_node("/root/Asteroid_Root_Node/detached_particles")
	var explosion_instance: Node2D = in_explosion_scene.instantiate()
	detached_root.add_child(explosion_instance)
	explosion_instance.global_position = ship.global_position

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Fire"): _fire_projectile()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	_movement_logik(delta)

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
		if !engine_is_running:
			toggle_engine_sounds(engine_is_running)
			thruster_particles.emitting = true
	else:
		ship.velocity = ship.velocity.lerp(Vector2.ZERO, clamp(BREAKING_POWER * delta, 0.0, 1.0))
		if engine_is_running:
			toggle_engine_sounds(engine_is_running)
			thruster_particles.emitting = false
	
	ship.move_and_slide() ## move and slide needs to be after any changed are made to velocity
	screen_wrap.screen_wrap()

##split the toggle to different functions? becauuse else always gets called...
func toggle_engine_sounds(is_sound_on : bool) -> void:
	if is_sound_on == false:
		engine_audio_control_token = AudioManager.play_looping_audio_stream(SHIP_ENGINE_RUNNING_SFX, &"SFX")
		engine_is_running = true
	else:
		AudioManager.stop_looping_audio_stream(engine_audio_control_token)
		engine_is_running = false

func _on_health_zero_health_reached() -> void:
	toggle_visibility(false)
	if ship_is_damaged:
		AudioManager.stop_looping_audio_stream(ship_damaged_audio_control_token)
		damaged_particles.emitting = false
		ship_is_damaged = false
	if engine_is_running:
		thruster_particles.emitting = false
		toggle_engine_sounds(engine_is_running)
	AudioManager.play_audio_stream(SHIP_DEATH_SFX, &"SFX")
	spawn_explosion(ship_explosion_scene)
	emit_signal("player_died")



func respawn() -> void:
	health._reset_health()
	ship.velocity = Vector2.ZERO
	ship.rotation = 0.0
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


func _on_is_damaged(_in_health) -> void:
	ship_is_damaged = true
	ship_damaged_audio_control_token = AudioManager.play_looping_audio_stream(SHIP_DAMAGED_SFX, &"SFX")
	var direction_x = randf_range(-1.0, 1.0)
	var direction_y = randf_range(-1.0, 1.0)
	var process_material: ParticleProcessMaterial = damaged_particles.process_material as ParticleProcessMaterial
	process_material.direction = Vector3(direction_x, direction_y, 0.0)
	damaged_particles.emitting = true

func reset_stats_ship() -> void:
	if ship_is_damaged:
		AudioManager.stop_looping_audio_stream(ship_damaged_audio_control_token)
		damaged_particles.emitting = false
	if engine_is_running:
		thruster_particles.emitting = false
		toggle_engine_sounds(engine_is_running)
	engine_is_running = false
	ship_is_damaged = false
