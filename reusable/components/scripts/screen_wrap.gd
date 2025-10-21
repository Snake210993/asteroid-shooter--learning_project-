extends Node2D


@onready var screen_size = get_viewport().size


func screen_wrap():
	get_parent().global_position.x = wrapf(get_parent().global_position.x, 0, screen_size.x)
	get_parent().global_position.y = wrapf(get_parent().global_position.y, 0, screen_size.y)
 
