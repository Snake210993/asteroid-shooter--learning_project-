extends asteroid

func _on_health_zero_health_reached() -> void:
	asteroid_collection.asteroids.erase(self)
	queue_free()
	asteroid_collection.points += 20
	print("small asteroid died - replace with audio")

func _ready() -> void:
	super()


func _on_spawn_invincibility_to_other_asteroids_timeout() -> void:
	set_collision_mask_value(3,true)
