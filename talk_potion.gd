extends Node2D


func _ready():
	$AnimatedSprite2D.play("idle")



func _on_exit_pressed():
	get_tree().change_scene_to_file("res://potion.tscn")

