extends Node

@onready var ui: Control = $UI_Root
@onready var respawn_panel: Control = $UI_Root/respawn_panel
@onready var player_ship: Node2D = $PlayerShip
@onready var game_over: Control = $UI_Root/game_over
@onready var main_menu: Control = $UI_Root/Main_Menu
@onready var credits: Control = $UI_Root/Credits
@onready var asteroid_spawner: Node2D = $Asteroid_Spawner
@onready var options: Control = $UI_Root/Options
@onready var highscore: highscore_class = $UI_Root/Highscore
@onready var pause_menu: Control = $UI_Root/pause_menu
@onready var enter_highscore_field: Control = $UI_Root/enter_highscore_field


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
const PAUSE_STATE = "pause"

var remaining_lives: int = 3
var state: String = "GameOver"  # "Alive", "WaitingForRespawn", "GameOver"
var current_menu: String = MAIN_MENU_STATE # "credits, "options", "highscore"

signal clean_asteroids
signal increase_difficulty


#region menu navigation
func _options_requested() -> void:
	main_menu.hide_main_menu()
	options.show_options()
	current_menu = OPTIONS_STATE

#region options menu
func _on_fullscreen_toggled(is_toggled : bool) -> void:
	if is_toggled: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_toggle_self_damage(is_toggled : bool) -> void:
	GLOBAL_DATA.is_self_damage_enabled = is_toggled
	print("self damage is = " + str(GLOBAL_DATA.is_self_damage_enabled))

func _on_ui_audio_changed(value : float) -> void:
	var new_ui_volume = linear_to_db(value)
	AudioManager.set_bus_volume(&"UI", new_ui_volume)

func _on_master_audio_changed(value : float) -> void:
	var new_master_volume = linear_to_db(value)
	AudioManager.set_bus_volume(&"Master", new_master_volume)

func _on_sfx_audio_changed(value : float) -> void:
	var new_sfx_volume = linear_to_db(value)
	AudioManager.set_bus_volume(&"SFX", new_sfx_volume)

func _on_music_audio_changed(value : float) -> void:
	var new_music_volume = linear_to_db(value)
	AudioManager.set_bus_volume(&"MUSIC", new_music_volume)
#endregion

func _highscore_requested() -> void:
	main_menu.hide_main_menu()
	highscore.show_highscore()
	GLOBAL_DATA.sort_highscores()
	highscore.apply_scores_to_highscores(GLOBAL_DATA.array_highscores_2d)
	current_menu = HIGHSCORE_STATE
	highscore.set_focus()

func _exit_game_requested() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST) #this should trigger saving and other quitting functionality
	GLOBAL_DATA.save_game()
	get_tree().quit()
func _credits_requested() -> void:
	main_menu.hide_main_menu()
	credits.show_credits()
	current_menu = CREDITS_STATE
	
func _back_requested() -> void:
	return_to_main(current_menu)
	main_menu.set_focus()
	
func return_to_main(returning_from_menu) -> void:
	match returning_from_menu:
		CREDITS_STATE:
			main_menu.show_main_menu()
			credits.hide_credits()
			current_menu = MAIN_MENU_STATE
		OPTIONS_STATE:
			main_menu.show_main_menu()
			options.hide_options()
			current_menu = MAIN_MENU_STATE
		HIGHSCORE_STATE:
			main_menu.show_main_menu()
			highscore.hide_highscore()
			current_menu = MAIN_MENU_STATE
		_:
			print("no_state")
func _on_respawn_requested() -> void:
	if state != "WaitingForRespawn":
		return
	ui.hide_respawn_panel()
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
	if get_tree().paused == true:
		_unpause_game()
		player_ship.visible = false
	state = "GameOver"
	player_ship.reset_stats_ship()
	main_menu.set_focus()

func _pause_game() -> void:
	get_tree().paused = true
	ui.show_pause_menu()
func _unpause_game() -> void:
	get_tree().paused = false
	ui.hide_pause_menu()
func _continue_requested() -> void:
	_unpause_game()


func _start_game_requested() -> void:
	main_menu.hide_main_menu()
	ui.show_game_ui()
	player_ship.toggle_visibility(true)
	player_ship.set_controllable(true)
	player_ship.respawn()
	GLOBAL_DATA.reset_points()
	ui.update_score(GLOBAL_DATA.points)
	emit_signal("clean_asteroids")
	asteroid_spawner.reset_difficulty()
	state = "Alive"
	current_point_threshold = 0
#endregion
#region UI updates
func _update_ui() -> void:
	ui.update_lives(remaining_lives)
	ui.update_score(GLOBAL_DATA.points)
func _show_game_over() -> void:
	ui.hide_game_ui()
	game_over.update_score()
	game_over.show_game_over()
func _show_new_highscore() -> void:
	enter_highscore_field.show_enter_name_field()
	enter_highscore_field.set_score_text(str(GLOBAL_DATA.points))
	enter_highscore_field.new_highscore_fluff()

#endregion
#region game state changes

func _on_player_died() -> void:
	if state != "Alive":
		return
	remaining_lives -= 1
	_update_ui()

	if remaining_lives > 0:
		state = "WaitingForRespawn"
		player_ship.set_controllable(false)
		ui.show_respawn_panel()
	else:
		state = "GameOver"
		player_ship.set_controllable(false)
		if _check_if_score_is_new_highscore(): _show_new_highscore()
		else : _show_game_over()

func _check_if_score_is_new_highscore() -> bool:
	GLOBAL_DATA.sort_highscores()
	if GLOBAL_DATA.points > GLOBAL_DATA.array_highscores_2d.get(0).get(0): return true
	else: return false


func _commit_to_highscore(new_name: String) -> void:
	##enter highscore into highscore 2d array
	GLOBAL_DATA.sort_highscores()
	GLOBAL_DATA.array_highscores_2d[0][1] = new_name
	GLOBAL_DATA.array_highscores_2d[0][0] = GLOBAL_DATA.points
	enter_highscore_field.hide_enter_name_field()
	_show_game_over()

#endregion
#region difficulty
func increase_difficulty_check(current_points : int):
	if current_points >= POINT_THRESHOLD_LEVEL_FOUR:
		if current_point_threshold < POINT_THRESHOLD_LEVEL_FOUR:
			emit_signal("increase_difficulty")
			current_point_threshold = POINT_THRESHOLD_LEVEL_FOUR
	elif current_points >= POINT_THRESHOLD_LEVEL_THREE:
		if current_point_threshold < POINT_THRESHOLD_LEVEL_THREE:
			emit_signal("increase_difficulty")
			current_point_threshold = POINT_THRESHOLD_LEVEL_THREE
	elif current_points >= POINT_THRESHOLD_LEVEL_TWO:
		if current_point_threshold < POINT_THRESHOLD_LEVEL_TWO:
			emit_signal("increase_difficulty")
			current_point_threshold = POINT_THRESHOLD_LEVEL_TWO
	elif current_points >= POINT_THRESHOLD_LEVEL_ONE:
		if current_point_threshold < POINT_THRESHOLD_LEVEL_ONE:
			emit_signal("increase_difficulty")
			current_point_threshold = POINT_THRESHOLD_LEVEL_ONE
#endregion


func _ready() -> void:
	player_ship.connect("player_died", Callable(self, "_on_player_died"))
	respawn_panel.connect("respawn", Callable(self, "_on_respawn_requested"))
	respawn_panel.connect("back_to_menu", Callable(self, "_back_to_menu_requested"))
	game_over.connect("back_to_menu", Callable(self, "_back_to_menu_requested"))
	pause_menu.connect("back_to_menu", Callable(self, "_back_to_menu_requested"))
	pause_menu.connect("continue_pressed", Callable(self, "_continue_requested"))
	
	main_menu.connect("start_game", Callable(self, "_start_game_requested"))
	main_menu.connect("options", Callable(self, "_options_requested"))
	main_menu.connect("highscore", Callable(self, "_highscore_requested"))
	main_menu.connect("exit_game", Callable(self, "_exit_game_requested"))
	main_menu.connect("credits", Callable(self, "_credits_requested"))
	
	credits.connect("back", Callable(self, "_back_requested"))
	options.connect("back", Callable(self, "_back_requested"))
	options.connect("fullscreen_toggle", Callable(self, "_on_fullscreen_toggled"))
	options.connect("self_damage_toggle", Callable(self, "_on_toggle_self_damage"))
	options.connect("ui_audio_changed", Callable(self, "_on_ui_audio_changed"))
	options.connect("master_audio_changed", Callable(self, "_on_master_audio_changed"))
	options.connect("sfx_audio_changed", Callable(self, "_on_sfx_audio_changed"))
	options.connect("music_audio_changed", Callable(self, "_on_music_audio_changed"))
	
	highscore.connect("back", Callable(self, "_back_requested"))
	enter_highscore_field.connect("name_submit", Callable(self, "_commit_to_highscore"))
	
	
	player_ship.toggle_visibility(false)
	player_ship.set_controllable(false)
	ui.hide_game_ui()
	
	AudioManager.play_radio_global(GAME_MUSIC, &"MUSIC")
	
	_update_ui()
	main_menu.set_focus()

func _on_receive_points() -> void:
	_update_ui()
	increase_difficulty_check(GLOBAL_DATA.points)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		if state == "Alive":
			_pause_game()
