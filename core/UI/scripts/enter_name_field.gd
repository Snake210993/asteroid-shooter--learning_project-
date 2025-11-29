extends Control


signal name_submit(new_name : String)

@onready var score_text: Label = $MarginContainer/VBoxContainer/score_text

func set_focus() -> void:
	$MarginContainer/VBoxContainer/field_enter_name.grab_focus()

func show_enter_name_field() -> void:
	visible = true
	set_focus()
func hide_enter_name_field() -> void:
	visible = false

func set_score_text(new_highscore : String) -> void:
	score_text.text = new_highscore

func _on_field_enter_name_text_submitted(new_text: String) -> void:
	name_submit.emit(new_text) # Replace with function body.

func new_highscore_fluff() -> void:
	print("enter fluff")
