extends Resource


##identifiers
const GAME_MUSIC_PLAYLIST_IDENTIFIER = "game_music_playlist_key"
const UI_BUTTON_HOVERED_IDENTIFIER = "ui_hovered_audio_key"
const UI_BUTTON_CLICKED_IDENTIFIER = "ui_clicked_audio_key"

##preloads
const GAME_MUSIC_PLAYLIST_RANDOM_MIXER = preload("uid://cxovxqfrvtdej") 
const UI_BUTTON_HOVERED = preload("uid://dv7ihypmrhlpl")
const UI_BUTTON_CLICKED = preload("uid://dokujvm725pfi")

const AUDIO_DICTIONARY : Dictionary = {
	ASTEROID_BREAKING_LARGE_IDENTIFIER : ASTEROID_BREAKING_LARGE_RANDOM_MIXER,
	ASTEROID_BREAKING_SMALL_IDENTIFIER : ASTEROID_BREAKING_SMALL_RANDOM_MIXER,
	SHIP_SHOOTING_IDENTIFIER : SHIP_SHOOTING_SFX,
	SHIP_DEATH_EXPLOSION_IDENTIFIER : SHIP_DEATH_EXPLOSION_SFX,
	UI_BUTTON_HOVERED_IDENTIFIER : UI_BUTTON_HOVERED,
	UI_BUTTON_CLICKED_IDENTIFIER : UI_BUTTON_CLICKED,
	GAME_MUSIC_PLAYLIST_IDENTIFIER : GAME_MUSIC_PLAYLIST_RANDOM_MIXER
	
}

func return_audio_data(audio_identifier) -> AudioStream:
	var returned_stream : AudioStream = AUDIO_DICTIONARY.get(audio_identifier)
	return returned_stream


##--------------------------------------------------------------------------------------------------
##bellow here is the game specific part of the resource

##identifiers
const ASTEROID_BREAKING_LARGE_IDENTIFIER = "asteroid_breaking_large"
const ASTEROID_BREAKING_SMALL_IDENTIFIER = "asteroid_breaking_small"
const SHIP_SHOOTING_IDENTIFIER = "ship_shooting_sfx"
const SHIP_DEATH_EXPLOSION_IDENTIFIER = "ship_death_explosion"


##preloads
const ASTEROID_BREAKING_LARGE_RANDOM_MIXER = preload("uid://buqy0m2hoh5uk")
const ASTEROID_BREAKING_SMALL_RANDOM_MIXER = preload("uid://b2k4ytb17sj1e")
const SHIP_SHOOTING_SFX = preload("uid://b4f2yi74epjt1")
const SHIP_DEATH_EXPLOSION_SFX = preload("uid://bv4uk4exn4f2t")
