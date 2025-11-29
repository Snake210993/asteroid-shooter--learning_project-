extends Node2D


var screen_size: Vector2

var IS_SCREEN_WRAPPING : bool = true

func _ready() -> void:
	_update_screen_size()
	get_viewport().size_changed.connect(_update_screen_size)

func _update_screen_size() -> void:
	var visible_rectangle : Rect2 = get_viewport().get_visible_rect()
	screen_size = visible_rectangle.size

func screen_wrap():
	if IS_SCREEN_WRAPPING:
		get_parent().global_position.x = wrapf(get_parent().global_position.x, 0, screen_size.x)
		get_parent().global_position.y = wrapf(get_parent().global_position.y, 0, screen_size.y)
 
