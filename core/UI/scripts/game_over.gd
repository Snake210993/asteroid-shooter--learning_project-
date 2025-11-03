extends Control
@onready var score: Label = $MarginContainer/VBoxContainer/HBoxContainer/Score



func update_score() -> void:
	score.text = str(GLOBAL_DATA.points)

func show_game_over() -> void:
	visible = true

func hide_game_over() -> void:
	visible = false
