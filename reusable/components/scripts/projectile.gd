extends Node2D

var direction : Vector2
var speed : float = 400.0
@onready var timer: Timer = $Timer
@onready var screen_wrap: Node2D = $Screen_Wrap


func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	screen_wrap.screen_wrap()

func shoot(new_position : Vector2, new_direction : Vector2) -> void:
	position = new_position
	direction = new_direction


func _on_timer_timeout() -> void:
	queue_free()
