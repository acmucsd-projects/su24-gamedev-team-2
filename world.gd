extends Node2D

var in_shop_range = false
var can_open_shop = false

func _process(_delta):
	if in_shop_range and can_open_shop:
		if Input.is_action_just_pressed("ui_right_click"):
			get_tree().change_scene_to_file("res://shop.tscn")

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
