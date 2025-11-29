extends Control

signal back_to_menu
signal respawn

func _on_ui_root_enable_respawn() -> void:
	visible = true
	

func set_focus() -> void:
	$MarginContainer/VBoxContainer/HBoxContainer/Yes.grab_focus()

func _on_yes_pressed() -> void:
	emit_signal("respawn")


func _on_end_pressed() -> void:
	emit_signal("back_to_menu")
