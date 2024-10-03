extends Control


@export_file("*.json") var d_file
var dialogue = []
var current_dialogue_id = 0
func _ready():
	current_dialogue_id = -1
var is_first_pressed1 = true
var is_first_pressed2 = true
var is_first_pressed3 = true


func load_dialogue1():
	if is_first_pressed1:
		current_dialogue_id = -1
	var file = FileAccess.open("res://dialogue/potiondialogue1.json", FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	return content
func load_dialogue2():
	if is_first_pressed2:
		current_dialogue_id = -1
	var file = FileAccess.open("res://dialogue/potiondialogue2.json", FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	return content
func load_dialogue3():
	if is_first_pressed3:
		current_dialogue_id = -1
	var file = FileAccess.open("res://dialogue/potiondialogue3.json", FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	return content
func _on_ingre_pressed():
	dialogue = load_dialogue1()
	is_first_pressed1 = false
func _on_new_pressed():
	dialogue = load_dialogue2()
	is_first_pressed2 = false
func _on_corruption_pressed():
	dialogue = load_dialogue3()
	is_first_pressed3  = false
	
func next_script():
	current_dialogue_id += 1
	if current_dialogue_id >= len(dialogue):
		return
	$NinePatchRect/Name.text = dialogue[current_dialogue_id]["name"]
	$NinePatchRect/Text.text = dialogue[current_dialogue_id]["text"]
func _input(event):
	if event.is_action_pressed("ui_space"):
		next_script()







