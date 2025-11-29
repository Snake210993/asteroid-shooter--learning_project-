extends Control
@onready var score: Label = $MarginContainer/VBoxContainer/HBoxContainer/Score

signal back_to_menu

func set_focus() -> void:
	$MarginContainer/VBoxContainer/button_with_sound.grab_focus()


func update_score() -> void:
	score.text = str(GLOBAL_DATA.points)

func show_game_over() -> void:
	visible = true
	set_focus()

func hide_game_over() -> void:
	visible = false


func _on_back_to_menu_pressed() -> void:
	emit_signal("back_to_menu")
