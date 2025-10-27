extends asteroid

func _on_health_zero_health_reached() -> void:
	queue_free()
	print("received 20 points")
	print("small asteroid died")

func _ready() -> void:
	super()
	print("small asteroid spawned")
