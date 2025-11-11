extends Button
@onready var hovered_sound: AudioStreamPlayer = $hovered_sound
@onready var clicked_sound: AudioStreamPlayer = $clicked_sound

@export var hovered_stream: AudioStream
@export var clicked_stream: AudioStream

# Exposed bus names with live dropdowns
@export var selected_bus: StringName


signal button_clicked
signal button_hovered


func _ready() -> void:
	hovered_sound.stream = hovered_stream
	clicked_sound.stream = clicked_stream
	clicked_sound.bus = selected_bus
	hovered_sound.bus = selected_bus


func _on_pressed() -> void:
	clicked_sound.play()
	emit_signal("button_clicked")


func _on_hovered() -> void:
	hovered_sound.play()
	emit_signal("button_hovered")
