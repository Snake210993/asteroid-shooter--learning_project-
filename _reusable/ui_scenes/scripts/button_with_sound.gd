extends Button

##button now uses AudioManager autoload! must be in project!

@export var is_using_hover_sound = false
@export var is_using_clicked_sound = false


const HOVERED_AUDIO_KEY : String = "ui_hovered_audio_key"
const CLICKED_AUDIO_KEY : String = "ui_clicked_audio_key"

const UI_STRING_NAME : StringName = &"UI"

signal button_clicked
signal button_hovered


func _on_pressed() -> void:
	if is_using_clicked_sound:
		AudioManager.play_audio_stream(CLICKED_AUDIO_KEY, UI_STRING_NAME)
	emit_signal("button_clicked")


func _on_hovered() -> void:
	if is_using_hover_sound:
		AudioManager.play_audio_stream(HOVERED_AUDIO_KEY, UI_STRING_NAME)
	emit_signal("button_hovered")
