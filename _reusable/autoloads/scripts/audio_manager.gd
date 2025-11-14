extends Node2D

##this plays music without local effects - for all to hear
@onready var radio_global: AudioStreamPlayer = $radio_global

##this is the list where all the audio files are preloaded and/or the paths are stored
@export var audio_list: Resource




func play_radio_global(audio_identifier : String, used_bus : StringName) -> void:
	var stream_to_be_played = _return_stream(audio_identifier)
	radio_global.stream = stream_to_be_played
	radio_global.bus = used_bus
	radio_global.play()

func _return_stream(audio_identifier : String) -> AudioStream:
	var stream_to_be_played = audio_list.return_audio_data(audio_identifier)
	return stream_to_be_played

func play_audio_stream(audio_identifier : String, used_bus : StringName) -> void:
	var audio_stream_player := AudioStreamPlayer.new()
	audio_stream_player.stream = _return_stream(audio_identifier)
	audio_stream_player.bus = used_bus
	add_child(audio_stream_player)
	audio_stream_player.finished.connect(func():
		audio_stream_player.queue_free())
	audio_stream_player.play()

func _create_new_audio_stream_player() -> AudioStreamPlayer:
	var audio_stream_player := AudioStreamPlayer.new()
	return audio_stream_player
	
