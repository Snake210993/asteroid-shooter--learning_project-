extends Node

@onready var ui: Control = $UI_Root
@onready var respawn_panel: Control = $UI_Root/respawn_panel
@onready var player_ship: Node2D = $PlayerShip
@onready var game_over: Control = $UI_Root/game_over
@onready var main_menu: Control = $UI_Root/Main_Menu
@onready var credits: Control = $UI_Root/Credits
@onready var asteroid_spawner: Node2D = $Asteroid_Spawner
@onready var options: Control = $UI_Root/Options
@onready var highscore: Control = $UI_Root/Highscore

const POINT_THRESHOLD_LEVEL_ONE : int = 500
const POINT_THRESHOLD_LEVEL_TWO : int = 1000
const POINT_THRESHOLD_LEVEL_THREE : int = 2000
const POINT_THRESHOLD_LEVEL_FOUR : int = 4000

var current_point_threshold : int = 0

const GAME_MUSIC = "game_music_playlist_key"

const CREDITS_STATE = "credits"
const MAIN_MENU_STATE = "main_menu"
const HIGHSCORE_STATE = "highscore"
const OPTIONS_STATE = "options"

var remaining_lives: int = 3
var state: String = "Alive"  # "Alive", "WaitingForRespawn", "GameOver"
var current_menu: String = MAIN_MENU_STATE # "credits, "options", "highscore"

signal clean_asteroids
signal increase_difficulty


#region menu navigation
func _options_requested() -> void:
	main_menu.visible = false
	options.visible = true
	current_menu = OPTIONS_STATE

#region options menu
func _on_fullscreen_toggled(is_toggled : bool) -> void:
	if is_toggled: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_ui_audio_changed(value : float) -> void:
	print("ui changed - new value = " + str(value))

func _on_master_audio_changed(value : float) -> void:
	print("master changed - new value = " + str(value))

func _on_sfx_audio_changed(value : float) -> void:
	print("sfx changed - new value = " + str(value))

func _on_music_audio_changed(value : float) -> void:
	print("music changed - new value = " + str(value))
#endregion

func _highscore_requested() -> void:
	main_menu.visible = false
	highscore.visible = true
	highscore.set_scores(GLOBAL_DATA.highscores)
	current_menu = HIGHSCORE_STATE

func _exit_game_requested() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST) #this should trigger saving and other quitting functionality
	get_tree().quit()
func _credits_requested() -> void:
	main_menu.visible = false
	credits.visible = true
	current_menu = CREDITS_STATE
	
func _back_requested() -> void:
	return_to_main(current_menu)
	
func return_to_main(returning_from_menu) -> void:
	match returning_from_menu:
		CREDITS_STATE:
			main_menu.visible = true
			credits.visible = false
			current_menu = MAIN_MENU_STATE
		OPTIONS_STATE:
			main_menu.visible = true
			options.visible = false
			current_menu = MAIN_MENU_STATE
		HIGHSCORE_STATE:
			main_menu.visible = true
			highscore.visible = false
			current_menu = MAIN_MENU_STATE
		_:
			print("no_state")
func _on_respawn_requested() -> void:
	if state != "WaitingForRespawn":
		return
	ui.hide_respawn_panel()
	#get_tree().paused = false
	player_ship.respawn()
	state = "Alive"
	
func _back_to_menu_requested() -> void:
	remaining_lives = 3
	ui.hide_game_ui()
	ui.reset_ui(remaining_lives)
	ui.hide_respawn_panel()
	game_over.hide_game_over()
	main_menu.show_main_menu()
	player_ship.set_controllable(false)
	

func _start_game_requested() -> void:
	main_menu.hide_main_menu()
	ui.show_game_ui()
	player_ship.toggle_visibility(true)
	player_ship.set_controllable(true)
	player_ship.health._reset_health()
	GLOBAL_DATA.reset_points()
	ui.update_score(GLOBAL_DATA.points)
	emit_signal("clean_asteroids")
	state = "Alive"
#endregion
#region UI updates
func _update_ui() -> void:
	ui.update_lives(remaining_lives)
	ui.update_score(GLOBAL_DATA.points)
func _show_game_over() -> void:
	ui.hide_game_ui()
	game_over.update_score()
	game_over.show_game_over()

#endregion
#region game state changes

func _on_player_died() -> void:
	if state != "Alive":
		return
	remaining_lives -= 1
	_update_ui()

	if remaining_lives > 0:
		state = "WaitingForRespawn"
		##should i pause game?
		player_ship.set_controllable(false)
		ui.show_respawn_panel()
	else:
		state = "GameOver"
		player_ship.set_controllable(false)
		GLOBAL_DATA.commit_to_highscore(GLOBAL_DATA.points)
		_show_game_over()


#endregion
#region difficulty
func increase_difficulty_check(current_points : int):
	if current_points >= POINT_THRESHOLD_LEVEL_FOUR:
		if current_point_threshold < POINT_THRESHOLD_LEVEL_FOUR:
			emit_signal("increase_difficulty")
			current_point_threshold = POINT_THRESHOLD_LEVEL_FOUR
			print("difficulty level 4 reached")
	elif current_points >= POINT_THRESHOLD_LEVEL_THREE:
		if current_point_threshold < POINT_THRESHOLD_LEVEL_THREE:
			emit_signal("increase_difficulty")
			current_point_threshold = POINT_THRESHOLD_LEVEL_THREE
			print("difficulty level 3 reached")
	elif current_points >= POINT_THRESHOLD_LEVEL_TWO:
		if current_point_threshold < POINT_THRESHOLD_LEVEL_TWO:
			emit_signal("increase_difficulty")
			current_point_threshold = POINT_THRESHOLD_LEVEL_TWO
			print("difficulty level 2 reached")
	elif current_points >= POINT_THRESHOLD_LEVEL_ONE:
		if current_point_threshold < POINT_THRESHOLD_LEVEL_ONE:
			emit_signal("increase_difficulty")
			current_point_threshold = POINT_THRESHOLD_LEVEL_ONE
			print("difficulty level 1 reached")
#endregion


func _ready() -> void:
	player_ship.connect("player_died", Callable(self, "_on_player_died"))
	respawn_panel.connect("respawn", Callable(self, "_on_respawn_requested"))
	respawn_panel.connect("back_to_menu", Callable(self, "_back_to_menu_requested"))
	game_over.connect("back_to_menu", Callable(self, "_back_to_menu_requested"))
	
	main_menu.connect("start_game", Callable(self, "_start_game_requested"))
	main_menu.connect("options", Callable(self, "_options_requested"))
	main_menu.connect("highscore", Callable(self, "_highscore_requested"))
	main_menu.connect("exit_game", Callable(self, "_exit_game_requested"))
	main_menu.connect("credits", Callable(self, "_credits_requested"))
	
	credits.connect("back", Callable(self, "_back_requested"))
	options.connect("back", Callable(self, "_back_requested"))
	options.connect("fullscreen_toggle", Callable(self, "_on_fullscreen_toggled"))
	options.connect("ui_audio_changed", Callable(self, "_on_ui_audio_changed"))
	options.connect("master_audio_changed", Callable(self, "_on_master_audio_changed"))
	options.connect("sfx_audio_changed", Callable(self, "_on_sfx_audio_changed"))
	options.connect("music_audio_changed", Callable(self, "_on_music_audio_changed"))
	
	highscore.connect("back", Callable(self, "_back_requested"))
	
	player_ship.toggle_visibility(false)
	player_ship.set_controllable(false)
	ui.hide_game_ui()
	
	AudioManager.play_radio_global(GAME_MUSIC, &"MUSIC")
	
	_update_ui()

func _on_receive_points() -> void:
	_update_ui()
	increase_difficulty_check(GLOBAL_DATA.points)
	
