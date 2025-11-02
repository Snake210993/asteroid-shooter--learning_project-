extends Control

signal button_no
signal respawn

func _on_ui_root_enable_respawn() -> void:
	visible = true


func _on_yes_pressed() -> void:
	emit_signal("respawn")


func _on_end_pressed() -> void:
	emit_signal("button_no")
