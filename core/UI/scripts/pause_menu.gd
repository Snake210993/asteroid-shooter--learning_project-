extends Control


signal continue_pressed
signal back_to_menu


func set_focus() -> void:
	$MarginContainer/VBoxContainer/continue.grab_focus()

func _on_back_to_menu_button_clicked() -> void:
	emit_signal("back_to_menu")


func _on_continue_button_clicked() -> void:
	emit_signal("continue_pressed")
