extends Control

@onready var current_value: Label = $MarginContainer/VBoxContainer/HBoxContainer/current_value
@onready var audio_slider: HSlider = $MarginContainer/VBoxContainer/Audio_Slider
@onready var slider_title: Label = $MarginContainer/VBoxContainer/SliderTitle

@export var SliderTitle : String



signal value_changed(float)

func _ready() -> void:
	current_value.text = str(audio_slider.value)
	slider_title.text = SliderTitle

func _on_audio_slider_value_changed(value: float) -> void:
	current_value.text = str(audio_slider.value)



func _on_audio_slider_drag_ended(_value_changed: bool) -> void:
	value_changed.emit(audio_slider.value)
