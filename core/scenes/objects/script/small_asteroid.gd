extends asteroid

const DEATH_AUDIO_2 = "asteroid_breaking_small"

func _on_health_zero_health_reached() -> void:
	GLOBAL_DATA.remove_self_from_asteroids(self)
	AudioManager.play_audio_stream(DEATH_AUDIO_2, &"SFX")
	GLOBAL_DATA.add_points(kill_score)
	spawn_explosion(export_explosion_scene)
	receive_points.emit()
	queue_free()


func _ready() -> void:
	super()
	damage_to_player = 50
	damage_to_asteroids = 5
	kill_score = 20

func _on_spawn_invincibility_to_other_asteroids_timeout() -> void:
	set_collision_mask_value(3,true)
