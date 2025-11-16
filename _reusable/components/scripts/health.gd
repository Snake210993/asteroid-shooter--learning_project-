extends Node2D

##this component handles health, it communicates when health ends trough a custom signal

##max health
@export var health : float = 100:
	get: return health
@export var max_health : float = 100:
	get: return max_health
	set(new_health): max_health = new_health

signal zero_health_reached
signal is_damaged

func take_damage(damage: float):
	health -= damage
	if health <= 0:
			zero_health()
			return
	if health < max_health: was_damaged()


func heal_damage(healing: float):
	health += healing

func was_damaged():
	is_damaged.emit(health)

func zero_health():
	emit_signal("zero_health_reached")

func _reset_health() -> void:
	health = max_health
