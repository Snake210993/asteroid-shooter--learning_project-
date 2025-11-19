extends Node2D

##this plays music without local effects - for all to hear
@onready var radio_global: AudioStreamPlayer = $radio_global

##this is the list where all the audio files are preloaded and/or the paths are stored
@onready var audio_list: Resource = load("res://_reusable/audio/audio_list/audio_list.tres")

##this stores the looping sounds using a String and AudioStreamPlayer
var active_looping_sounds : Dictionary[String, AudioStreamPlayer]


func play_radio_global(audio_identifier : String, used_bus : StringName) -> void:
	var stream_to_be_played = _return_stream(audio_identifier)
	radio_global.stream = stream_to_be_played
	radio_global.bus = used_bus
	radio_global.play()


func play_looping_audio_stream(audio_identifier : String, used_bus : StringName) -> String:
	var looping_audio_stream_player := AudioStreamPlayer.new()
	looping_audio_stream_player = _set_audio_stream_player(looping_audio_stream_player, audio_identifier, used_bus)
	add_child(looping_audio_stream_player)
	looping_audio_stream_player.play()
	var audio_control_token : String = str(looping_audio_stream_player)
	active_looping_sounds[audio_control_token] = looping_audio_stream_player
	return audio_control_token

func stop_looping_audio_stream(audio_control_token : String):
	var audio_player_to_be_stopped : AudioStreamPlayer = active_looping_sounds.get(audio_control_token)
	if audio_player_to_be_stopped != null:
		audio_player_to_be_stopped.stop()
		audio_player_to_be_stopped.emit_signal("finished")
		audio_player_to_be_stopped.finished.connect(func():
			audio_player_to_be_stopped.queue_free())
	else: push_error("ERROR: tried to free null AudioStreamPlayer")

func play_audio_stream(audio_identifier : String, used_bus : StringName) -> void:
	var audio_stream_player := AudioStreamPlayer.new()
	audio_stream_player = _set_audio_stream_player(audio_stream_player, audio_identifier, used_bus)
	add_child(audio_stream_player)
	audio_stream_player.finished.connect(func():
		audio_stream_player.queue_free())
	audio_stream_player.play()

func _create_new_audio_stream_player() -> AudioStreamPlayer:
	var audio_stream_player := AudioStreamPlayer.new()
	return audio_stream_player

func _set_audio_stream_player(stream_to_populate : AudioStreamPlayer, audio_identifier : String, used_bus : StringName) -> AudioStreamPlayer:
	stream_to_populate.stream = _return_stream(audio_identifier)
	stream_to_populate.bus = used_bus
	return stream_to_populate


func _return_stream(audio_identifier : String) -> AudioStream:
	var stream_to_be_played = audio_list.return_audio_data(audio_identifier)
	return stream_to_be_played
