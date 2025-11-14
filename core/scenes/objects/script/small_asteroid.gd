extends asteroid

const DEATH_AUDIO_2 = "asteroid_breaking_small"

func _on_health_zero_health_reached() -> void:
	GLOBAL_DATA.remove_self_from_asteroids(self)
	AudioManager.play_audio_stream(DEATH_AUDIO_2, &"SFX")
	queue_free()
	GLOBAL_DATA.add_points(kill_score)
	receive_points.emit()

func _ready() -> void:
	super()
	damage_to_player = 25
	damage_to_asteroids = 5
	kill_score = 20

func _on_spawn_invincibility_to_other_asteroids_timeout() -> void:
	set_collision_mask_value(3,true)
