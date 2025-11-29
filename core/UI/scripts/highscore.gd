extends Control

class_name highscore_class

signal back


@export var array_of_labels: Array[Label]
@export var name_label_lookup : Dictionary[Label, Label]

@onready var highscore_container: VBoxContainer = $MarginContainer/HighscoreContainer

const TOTAL_LEADER_BOARD_AMOUNT = 4



var testing_name_counter = 0


func _ready() -> void:
	_populate_array_of_scores(GLOBAL_DATA.highscores)

func set_focus() -> void:
	$MarginContainer/button_with_sound.grab_focus()

func show_highscore() -> void:
	visible = true
	set_focus()
	
func hide_highscore() -> void:
	visible = false
func _on_button_with_sound_button_clicked() -> void:
	emit_signal("back")

func _populate_array_of_scores(array_of_scores : Array) -> void:
	for i in range(array_of_labels.size()):
		array_of_scores.push_back(int(array_of_labels.get(i).text))


func add_new_highscore(new_name : String, new_highscore : int, array_of_scores : Array) -> void:
	array_of_scores.sort()
	var score_to_be_removed : int = array_of_scores.get(0)
	if score_to_be_removed > new_highscore:
		push_error("ERROR: new score lower than lowest highscore")
		return
	for i in range(array_of_labels.size()):
		if str(score_to_be_removed) == array_of_labels.get(i).text:
			array_of_labels.get(i).text = str(new_highscore)
			name_label_lookup.get(array_of_labels.get(i)).text = new_name
			array_of_scores.push_back(new_highscore)
			array_of_scores.sort()
			array_of_scores.remove_at(0)
			break



func sort_highscores(array_of_scores : Array) -> void:
	array_of_scores.sort()
	var current_slot = TOTAL_LEADER_BOARD_AMOUNT
	for n in array_of_scores:
		for i in range(array_of_labels.size()):
			if str(n) == array_of_labels.get(i).text:
				var highscore_to_be_moved = array_of_labels.get(i).get_parent()
				highscore_container.move_child(highscore_to_be_moved, current_slot)
				current_slot -= 1
