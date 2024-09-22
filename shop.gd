extends Node2D
@onready var anim = $AnimationPlayer
#func _ready():
	#var player = get_node("player")
	#player.position = Vector2(1055,590)
func _on_exit_pressed():
	get_tree().change_scene_to_file("res://world.tscn")


