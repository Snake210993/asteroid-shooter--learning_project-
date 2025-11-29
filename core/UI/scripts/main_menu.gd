extends Control

signal start_game
signal options
signal highscore
signal exit_game
signal credits



func set_focus() -> void:
	$MarginContainer/VBoxContainer/start_game.grab_focus()

func hide_main_menu() -> void:
	visible = false
func show_main_menu() -> void:
	visible = true

func _on_start_game_pressed() -> void:
	emit_signal("start_game")


func _on_options_pressed() -> void:
	emit_signal("options")


func _on_highscore_pressed() -> void:
	emit_signal("highscore")


func _on_exit_game_pressed() -> void:
	emit_signal("exit_game")

func _on_credits_pressed() -> void:
	emit_signal("credits") # Replace with function body.
