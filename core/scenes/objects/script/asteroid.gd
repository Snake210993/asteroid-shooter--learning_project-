extends RigidBody2D

@onready var screen_wrap: Node2D = $Screen_Wrap

var thrust = Vector2(45, 45)
var torque = 20
var damage = 50

func _ready() -> void:
	
	linear_velocity = thrust
	constant_torque = torque

func _physics_process(_delta: float) -> void:
	screen_wrap.screen_wrap()

func _on_collision(body: Node) -> void:
	if body.has_node("Health"):
		var Health = body.get_node("Health")
		Health.take_damage(damage)
		

func _on_health_zero_health_reached() -> void:
	queue_free()
	print("asteroid died")
