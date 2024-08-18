@icon("res://npc/icon/npc.svg")
class_name Npc1 extends CharacterBody2D

signal do_behavior_enabled

var state: String="idle"
var direction : Vector2 = Vector2.DOWN
var direction_name : String = "down"

@export var npc_resource: NPCResource

@onready var sprite: Sprite2D = $Sprite2D

@onready var animation: AnimationPlayer = $AnimationPlayer

func _ready():
	setup_npc()
	pass
	
	
func setup_npc():
	if npc_resource:
		sprite.texture=npc_resource.sprite
	pass














