extends asteroid

func _on_health_zero_health_reached() -> void:
	GLOBAL_DATA.asteroids.erase(self)
	queue_free()
	GLOBAL_DATA.points += 20
	receive_points.emit()
	print("small asteroid died - replace with audio")

func _ready() -> void:
	super()
	damage_to_player = 25
	damage_to_asteroids = 5

func _on_spawn_invincibility_to_other_asteroids_timeout() -> void:
	set_collision_mask_value(3,true)
