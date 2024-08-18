extends Node2D

func _on_respawn_pressed():
	Global.player_position = Vector2(0, 0)
	Global.player_health = 100
	Global.player_direction_left = false

	Global.enemy_position = Vector2(847, 222)
	Global.enemy_health = 20
	Global.enemy_direction_left = false
	Global.enemy_respawn = true
	get_tree().change_scene_to_file("res://world.tscn")

func _on_exit_pressed():
	get_tree().quit()
