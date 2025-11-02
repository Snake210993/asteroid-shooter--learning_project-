extends Node

@onready var ui: Control = $UI_Root
@onready var respawn_panel: Control = $UI_Root/respawn_panel
@onready var player_ship: Node2D = $PlayerShip
@onready var game_over: Control = $UI_Root/game_over

var remaining_lives: int = 3
var state: String = "Alive"  # "Alive", "WaitingForRespawn", "GameOver"

func _ready() -> void:
	player_ship.connect("player_died", Callable(self, "_on_player_died"))
	respawn_panel.connect("respawn", Callable(self, "_on_respawn_requested"))
	respawn_panel.connect("button_no", Callable(self, "_on_end_requested"))
	
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
		#get_tree().paused = true
		ui.show_respawn_panel()
	else:
		state = "GameOver"
		_show_game_over()

func _show_game_over() -> void:
	game_over.visible = true

func _on_respawn_requested() -> void:
	if state != "WaitingForRespawn":
		return
	ui.hide_respawn_panel()
	#get_tree().paused = false
	player_ship.respawn()
	state = "Alive"
