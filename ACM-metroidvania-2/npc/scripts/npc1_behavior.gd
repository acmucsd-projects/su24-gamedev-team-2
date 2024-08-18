@icon("res://npc/icons/npc_behavior.svg")
class_name NPCBehavior extends Node2D

var npc: Npc1

func _ready() -> void: 
	var p = get_parent()
	if p is Npc1:
		npc = p as Npc1
		#connect to signal
