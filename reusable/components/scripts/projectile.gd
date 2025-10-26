extends Node2D

##move to resource file? -> difficulty options
const SELF_DAMAGE_FLAG = true

var direction : Vector2
var speed : float = 400.0
var damage : float = 50.0
@onready var timer: Timer = $Timer
@onready var self_damage: Timer = $Self_Damage
@onready var screen_wrap: Node2D = $Screen_Wrap
@onready var projectile_area: Area2D = $Projectile_Area


func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	screen_wrap.screen_wrap()

func shoot(new_position : Vector2, new_direction : Vector2) -> void:
	position = new_position
	direction = new_direction


func _on_timer_timeout() -> void:
	queue_free()

func _on_projectile_area_body_entered(body: Node2D) -> void:
	if body.has_node("Health"):
		var Health = body.get_node("Health")
		Health.take_damage(damage)
	queue_free()


func _on_self_damage_timeout() -> void:
	if SELF_DAMAGE_FLAG:
		projectile_area.set_collision_mask_value(1, true)
