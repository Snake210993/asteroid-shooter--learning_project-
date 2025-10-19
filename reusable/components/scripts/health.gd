extends Node2D

##this component handles health, it communicates when health ends trough a custom signal

##max health
@export var health : float = 200

signal zero_health_reached

func take_damage(damage: float):
	health -= damage

func heal_damage(healing: float):
	health += healing
	
func zero_health():
	emit_signal("zero_health_reached")


func _process(_delta: float) -> void:
	if health <= 0 : zero_health()
