extends Control

class_name highscore_class

signal back


const TOTAL_LEADER_BOARD_AMOUNT = 4

@onready var nr_5: Label = $MarginContainer/HighscoreContainer/Highscore5/Nr_5
@onready var name_5: Label = $MarginContainer/HighscoreContainer/Highscore5/Name_5
@onready var nr_4: Label = $MarginContainer/HighscoreContainer/Highscore4/Nr_4
@onready var name_4: Label = $MarginContainer/HighscoreContainer/Highscore4/Name_4
@onready var nr_3: Label = $MarginContainer/HighscoreContainer/Highscore3/Nr_3
@onready var name_3: Label = $MarginContainer/HighscoreContainer/Highscore3/Name_3
@onready var nr_2: Label = $MarginContainer/HighscoreContainer/Highscore2/Nr_2
@onready var name_2: Label = $MarginContainer/HighscoreContainer/Highscore2/Name_2
@onready var nr_1: Label = $MarginContainer/HighscoreContainer/Highscore1/Nr_1
@onready var name_1: Label = $MarginContainer/HighscoreContainer/Highscore1/Name_1




var testing_name_counter = 0

func highscores_loaded(scores : Array) -> void:
	apply_scores_to_highscores(scores)

func _ready() -> void:
	highscores_loaded(GLOBAL_DATA.array_highscores_2d)

func set_focus() -> void:
	$MarginContainer/button_with_sound.grab_focus()

func show_highscore() -> void:
	visible = true
	set_focus()
	
func hide_highscore() -> void:
	visible = false
func _on_button_with_sound_button_clicked() -> void:
	emit_signal("back")

func apply_scores_to_highscores(scores : Array) -> void:
	nr_5.text = str(scores.get(0).get(0))
	name_5.text = scores.get(0).get(1)
	nr_4.text = str(scores.get(1).get(0))
	name_4.text = scores.get(1).get(1)
	nr_3.text = str(scores.get(2).get(0))
	name_3.text = scores.get(2).get(1)
	nr_2.text = str(scores.get(3).get(0))
	name_2.text = scores.get(3).get(1)
	nr_1.text = str(scores.get(4).get(0))
	name_1.text = scores.get(4).get(1)
