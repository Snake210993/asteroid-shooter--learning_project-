extends Control
@onready var score_value: Label = $MarginContainer/Score_Container/Value

@onready var life: TextureRect = $MarginContainer/Lives_Container/Life
@onready var life_2: TextureRect = $MarginContainer/Lives_Container/Life2
@onready var life_3: TextureRect = $MarginContainer/Lives_Container/Life3

@onready var respawn_panel: Control = $respawn_panel
@onready var margin_container: MarginContainer = $MarginContainer
@onready var pause_menu: Control = $pause_menu


func _ready() -> void:
	update_score(GLOBAL_DATA.points)
	update_lives(3)
	hide_respawn_panel()

func update_score(points: int) -> void:
	score_value.text = str(points)

func update_lives(lives: int) -> void:
	life.visible = lives >= 1
	life_2.visible = lives >= 2
	life_3.visible = lives >= 3

func show_respawn_panel() -> void:
	respawn_panel.visible = true
	respawn_panel.set_focus()

func hide_respawn_panel() -> void:
	respawn_panel.visible = false

func hide_game_ui() -> void:
	margin_container.visible = false
func show_game_ui() -> void:
	margin_container.visible = true
	
func show_pause_menu() -> void:
	pause_menu.visible = true
	pause_menu.set_focus()
func hide_pause_menu() -> void:
	pause_menu.visible = false

func reset_ui(remaining_lives : int) -> void:
	update_lives(remaining_lives)
