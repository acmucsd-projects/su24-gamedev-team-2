extends Node2D
@onready var anim = $AnimationPlayer
@onready var camera = $Camera2D

func _ready():
	var player = get_node("player")
	player.position = Vector2(550, 1350)
	#camera.position = Vector2(500, 300)  # Example static position
	#var default_zoom = Vector2(1, 1)
	#camera.zoom = default_zoom
func _on_exit_pressed():
	get_tree().change_scene_to_file("res://world.tscn")


