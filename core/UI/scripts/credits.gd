extends Control

signal back


func _on_back_button_button_clicked() -> void:
	emit_signal("back")

func set_focus() -> void:
	$MarginContainer/back_button.grab_focus()
func show_credits() -> void:
	visible = true
	set_focus()
func hide_credits() -> void:
	visible = false
