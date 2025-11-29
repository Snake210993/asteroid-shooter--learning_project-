extends RigidBody2D

class_name asteroid

@onready var screen_wrap: Node2D = $Screen_Wrap
@onready var screen_size = get_viewport().size
@onready var death_audio: AudioStreamPlayer = $death_audio

@export var export_explosion_scene : PackedScene

const ASTEROID_DEATH_AUDIO = "asteroid_breaking_large"

var kill_score = 40

var max_fracture_amount = 5

signal has_fractured_spawn_small_asteroids
signal receive_points

var fracture_amount

var has_entered_viewport: bool = false

var thrust : Vector2
var torque : float
var damage_to_player = 100
var damage_to_asteroids = 10

var last_obj_to_damage

func spawn_explosion(in_explosion_scene : PackedScene) -> void:
	var detached_root: Node = get_node("/root/Asteroid_Root_Node/detached_particles")
	var explosion_scene: PackedScene = in_explosion_scene
	var explosion_instance: Node2D = explosion_scene.instantiate()
	detached_root.add_child(explosion_instance)
	explosion_instance.global_position = global_position


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
	fracture_amount = randi_range(0, max_fracture_amount)
	



func _physics_process(_delta: float) -> void:
	if (has_entered_viewport):
		screen_wrap.IS_SCREEN_WRAPPING = true
	screen_wrap.screen_wrap()

func _on_collision(body: Node) -> void:
	if body.has_node("Health"):
		var Health = body.get_node("Health")
		if body.is_in_group("Player"):
			Health.take_damage(damage_to_player)

func _on_health_zero_health_reached() -> void:
	has_fractured_spawn_small_asteroids.emit(fracture_amount, global_position, linear_velocity)
	GLOBAL_DATA.remove_self_from_asteroids(self)
	GLOBAL_DATA.add_points(kill_score)
	receive_points.emit()
	AudioManager.play_audio_stream(ASTEROID_DEATH_AUDIO, &"SFX")
	spawn_explosion(export_explosion_scene)
	queue_free()
	
func edit_fracture_amount(new_fracture_amount : int) -> void:
	max_fracture_amount = new_fracture_amount
