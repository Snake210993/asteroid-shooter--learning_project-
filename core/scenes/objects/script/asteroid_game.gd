extends Node

@onready var ui: Control = $UI_Root
@onready var respawn_panel: Control = $UI_Root/respawn_panel
@onready var player_ship: Node2D = $PlayerShip
@onready var game_over: Control = $UI_Root/game_over
@onready var main_menu: Control = $UI_Root/Main_Menu
@onready var credits: Control = $UI_Root/Credits
@onready var asteroid_spawner: Node2D = $Asteroid_Spawner


const GAME_MUSIC = "game_music_playlist_key"

const CREDITS_STATE = "credits"
const MAIN_MENU_STATE = "main_menu"
const HIGHSCORE_STATE = "highscore"
const OPTIONS_STATE = "options"

var remaining_lives: int = 3
var state: String = "Alive"  # "Alive", "WaitingForRespawn", "GameOver"
var current_menu: String = MAIN_MENU_STATE # "credits, "options", "highscore"

signal clean_asteroids


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
	
	player_ship.toggle_visibility(false)
	player_ship.set_controllable(false)
	ui.hide_game_ui()
	
	AudioManager.play_radio_global(GAME_MUSIC, &"MUSIC")
	
	_update_ui()

func _on_receive_points() -> void:
	_update_ui()

func _update_ui() -> void:
	ui.update_lives(remaining_lives)
	ui.update_score(GLOBAL_DATA.points)
	
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
		_show_game_over()

func _show_game_over() -> void:
	ui.hide_game_ui()
	game_over.update_score()
	game_over.show_game_over()

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


func _options_requested() -> void:
	print("options")

func _highscore_requested() -> void:
	print("highscore")

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
			#hide options
			current_menu = MAIN_MENU_STATE
		HIGHSCORE_STATE:
			main_menu.visible = true
			#hide highscore
			current_menu = MAIN_MENU_STATE
		_:
			print("no_state")
