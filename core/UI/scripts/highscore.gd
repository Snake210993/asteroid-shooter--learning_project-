extends Control

signal back

@onready var nr_5: Label = $MarginContainer/VBoxContainer/HBoxContainer5/Nr_5
@onready var nr_4: Label = $MarginContainer/VBoxContainer/HBoxContainer4/Nr_4
@onready var nr_3: Label = $MarginContainer/VBoxContainer/HBoxContainer3/Nr_3
@onready var nr_2: Label = $MarginContainer/VBoxContainer/HBoxContainer2/Nr_2
@onready var nr_1: Label = $MarginContainer/VBoxContainer/HBoxContainer/Nr_1


 
func _on_button_with_sound_button_clicked() -> void:
	emit_signal("back")
	


func set_scores(array_of_scores : Array[int]) -> void:
	array_of_scores.sort()
	nr_5.text = str(array_of_scores.get(0))
	nr_4.text = str(array_of_scores.get(1))
	nr_3.text = str(array_of_scores.get(2))
	nr_2.text = str(array_of_scores.get(3))
	nr_1.text = str(array_of_scores.get(4))
