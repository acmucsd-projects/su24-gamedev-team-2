extends Node2D

var in_shop_range = false
var can_open_shop = false

var in_lava_range = false
var can_teleport_to_lava = false

func _process(_delta):
	if in_shop_range and can_open_shop:
		if Input.is_action_just_pressed("ui_right_click"):
			get_tree().change_scene_to_file("res://shop.tscn")
	if in_lava_range and can_teleport_to_lava:
		if Input.is_action_just_pressed("ui_right_click"):
			Global.player_position = Vector2(2160, 217)
			#aGlobal.enemy_position = Vector2(177, 544)
			get_tree().change_scene_to_file("res://lava_zone.tscn")

func _on_shop_detection_body_entered(body):
	if body.name == "player":
		in_shop_range = true

func _on_shop_detection_body_exited(body):
	if body.name == "player":
		in_shop_range = false

func _on_shop_panel_mouse_entered():
	can_open_shop = true

func _on_shop_panel_mouse_exited():
	can_open_shop = false


func _on_lava_zone_detection_body_entered(body):
	if body.name == "player":
		in_lava_range = true

func _on_lava_zone_detection_body_exited(body):
	if body.name == "player":
		in_lava_range = false

func _on_lava_panel_mouse_entered():
	can_teleport_to_lava = true

func _on_lava_panel_mouse_exited():
	can_teleport_to_lava = false
