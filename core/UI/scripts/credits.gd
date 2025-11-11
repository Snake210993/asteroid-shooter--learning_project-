extends Control

signal back


func _on_back_button_button_clicked() -> void:
	emit_signal("back")
