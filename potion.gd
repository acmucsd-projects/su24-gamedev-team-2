extends Node2D

var gold = 10000
var items = {
	0: {
		"Name": "Regular Potion",
		"Des": "5 temp health in 10 seconds",
		"Cost": 10
	},
	1: {
		"Name": "Medium Potion",
		"Des": "10 temp health in 5 seconds",
		"Cost": 15
	},
	2: {
		"Name": "Strong Potion",
		"Des": "10 temp health in 2 seconds",
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
			get_node("Control/des").text = items[currentItem]["Des"]
			get_node("Control/des").text += "\nCost "+str(items[currentItem]["Cost"])
func _on_buy_pressed():
	var hasItem = false
	if gold >= items[currentItem]["Cost"]:
		for i in inventory:
			if inventory[i]["Name"] == items[currentItem]["Name"]:
				inventory[i]["Count"] += 1
				hasItem = true
		if hasItem == false:
			var tempDict = items[currentItem]
			tempDict["Count"] = 1
			inventory[inventory.size()]= tempDict
		gold -= items[currentItem]["Cost"]
		


func _on_prev_pressed():
	switch_item(currentItem -1)


func _on_next_pressed():
	switch_item(currentItem +1)

func _ready():
	$Control/AnimatedSprite2D.play("idle")
func _on_talk_pressed():
	$Control/AnimatedSprite2D.play("talk")
	$Control/Timer.start()
	get_tree().change_scene_to_file("res://talk_potion.tscn")


func _on_timer_timeout():
	$Control/AnimatedSprite2D.play("idle")
