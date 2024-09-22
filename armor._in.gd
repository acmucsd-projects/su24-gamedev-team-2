extends Node2D

var gold = 10000
var items = {
	0: {
		"Name": "Bronze Armor",
		"Des": "5 additional health",
		"Cost": 10
	},
	1: {
		"Name": "Silver Armor",
		"Des": "10 additional health",
		"Cost": 15
	},
	2: {
		"Name": "Gold Armor",
		"Des": "15 additional health",
		"Cost": 35
	}
};

var inventory = {
	0: {
		"Name": "Bronze Armor",
		"Des": "5 additional health",
		"Cost": 10,
		"Count": 1
	}
};


func _on_exit_pressed():
	get_tree().change_scene_to_file("res://town.tscn")

var currentItem = 0
var select = 0


func switch_item(select):
	for i in range (items.size()):
		if select == i:
			currentItem = select
			get_node("Control/name").text = items[currentItem]["Name"]
func _on_buy_pressed():
	pass # Replace with function body.


func _on_prev_pressed():
	switch_item(currentItem -1)


func _on_next_pressed():
	switch_item(currentItem +1)
