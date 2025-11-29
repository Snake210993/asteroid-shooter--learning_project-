extends Control


signal back

signal fullscreen_toggle
signal self_damage_toggle(bool)
signal ui_audio_changed
signal master_audio_changed
signal sfx_audio_changed
signal music_audio_changed

func set_focus() -> void:
	$button_with_sound.grab_focus()
	
func show_options() -> void:
	visible = true
	set_focus()
func hide_options() -> void:
	visible = false

func _on_toggle_self_damage_toggled(toggled_on: bool) -> void:
	self_damage_toggle.emit(toggled_on)

func _on_back_button_button_clicked() -> void:
	emit_signal("back")


func _on_master_changed(new_value : float) -> void:
	master_audio_changed.emit(new_value)


func _on_sfx_changed(new_value : float) -> void:
	sfx_audio_changed.emit(new_value)

func _on_music_changed(new_value : float) -> void:
	music_audio_changed.emit(new_value)

func _on_ui_changed(new_value : float) -> void:
	ui_audio_changed.emit(new_value)



func _on_toggle_full_screen_toggled(toggled_on: bool) -> void:
	fullscreen_toggle.emit(toggled_on)
