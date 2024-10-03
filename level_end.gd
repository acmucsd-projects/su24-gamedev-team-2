extends Node2D



func _on_back_to_town_pressed():
	Global.player_position = Vector2(0, 0)
	Global.player_health = 100
	Global.player_direction_left = false
	Global.respawn = true

	Global.enemy_health = 20
	Global.enemy_direction_left = false
	Global.enemy_respawn = true
	
	Global.num_enemies = 1
	Global.kill_all_enemies = false
	
	get_tree().change_scene_to_file("res://world.tscn")


func _on_next_level_pressed():
	get_tree().change_scene_to_file("res://world.tscn")
