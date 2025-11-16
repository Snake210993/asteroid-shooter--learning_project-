extends Resource

#error constants
const ERR_AUDIO_STREAM_INVALID_OR_NULL : String = "ERROR: audio stream invalid or null"


#identifiers
const GAME_MUSIC_PLAYLIST_IDENTIFIER : String = "game_music_playlist_key"


#preloads
const GAME_MUSIC_PLAYLIST_RANDOM_MIXER : AudioStream = preload("uid://cxovxqfrvtdej")

const AUDIO_DICTIONARY : Dictionary [String, AudioStream] = {

	GAME_MUSIC_PLAYLIST_IDENTIFIER : GAME_MUSIC_PLAYLIST_RANDOM_MIXER,
	##______________________________________________________
	##below are UI specific parts of the AudioManager Dictionary
	##______________________________________________________
	UI_BUTTON_HOVERED_IDENTIFIER : UI_BUTTON_HOVERED,
	UI_BUTTON_CLICKED_IDENTIFIER : UI_BUTTON_CLICKED,
	##______________________________________________________
	##below are game specific parts of the AudioManager Dictionary
	##______________________________________________________
	ASTEROID_BREAKING_LARGE_IDENTIFIER : ASTEROID_BREAKING_LARGE_RANDOM_MIXER,
	ASTEROID_BREAKING_SMALL_IDENTIFIER : ASTEROID_BREAKING_SMALL_RANDOM_MIXER,
	SHIP_SHOOTING_IDENTIFIER : SHIP_SHOOTING_SFX,
	SHIP_DEATH_EXPLOSION_IDENTIFIER : SHIP_DEATH_EXPLOSION_SFX,
	SHIP_DAMAGED_IDENTIFIER : SHIP_DAMAGED_SFX
}

func return_audio_data(audio_identifier) -> AudioStream:
	var returned_stream : AudioStream = AUDIO_DICTIONARY.get(audio_identifier)
	if returned_stream == null:
		push_error(ERR_AUDIO_STREAM_INVALID_OR_NULL)
		push_error("ERROR with IDENTIFIER: " + audio_identifier)
	return returned_stream

##--------------------------------------------------------------------------------------------------
##bellow here is the UI specific part of the resource
##--------------------------------------------------------------------------------------------------

#identifiers
const UI_BUTTON_HOVERED_IDENTIFIER : String = "ui_hovered_audio_key"
const UI_BUTTON_CLICKED_IDENTIFIER : String = "ui_clicked_audio_key"

#preloads
const UI_BUTTON_HOVERED : AudioStream = preload("uid://dv7ihypmrhlpl")
const UI_BUTTON_CLICKED : AudioStream = preload("uid://dokujvm725pfi")

##--------------------------------------------------------------------------------------------------
##bellow here is the game specific part of the resource
##--------------------------------------------------------------------------------------------------

#identifiers
const ASTEROID_BREAKING_LARGE_IDENTIFIER = "asteroid_breaking_large"
const ASTEROID_BREAKING_SMALL_IDENTIFIER = "asteroid_breaking_small"
const SHIP_SHOOTING_IDENTIFIER = "ship_shooting_sfx"
const SHIP_DAMAGED_IDENTIFIER = "ship_damaged_sfx"
const SHIP_DEATH_EXPLOSION_IDENTIFIER = "ship_death_explosion"


#preloads
const ASTEROID_BREAKING_LARGE_RANDOM_MIXER = preload("uid://buqy0m2hoh5uk")
const ASTEROID_BREAKING_SMALL_RANDOM_MIXER = preload("uid://b2k4ytb17sj1e")
const SHIP_SHOOTING_SFX = preload("uid://b4f2yi74epjt1")
const SHIP_DEATH_EXPLOSION_SFX = preload("uid://bv4uk4exn4f2t")
const SHIP_DAMAGED_SFX = preload("uid://cyqssa707gyxj")
