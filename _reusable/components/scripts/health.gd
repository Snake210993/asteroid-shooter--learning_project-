extends Node2D

##this component handles health, it communicates when health ends trough a custom signal
class_name HealthComponent

##max health
@export var health : float = 100:
	set(new_health):
		health = clamp(new_health, 0.0, max_health)
@export var max_health : float = 100

signal zero_health_reached
signal damaged
signal healed

func take_damage(damage: float):
	health -= damage
	if health <= 0:
			zero_health()
			return
	if health < max_health: was_damaged()


func heal_damage(healing: float):
	health += healing
	healed.emit(health)

func was_damaged():
	damaged.emit(health)

func zero_health():
	emit_signal("zero_health_reached")

func _reset_health() -> void:
	health = max_health
