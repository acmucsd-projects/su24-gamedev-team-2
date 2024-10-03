extends Area2D
var in_range = false
var can_open = false



func _on_body_entered(body):
	if body.name == "player":
		in_range = true


func _on_body_exited(body):
	if body.name == "player":
		in_range = false
	

func _on_mouse_entered():
	can_open = true


func _on_mouse_exited():
	can_open = false

func _process(delta):
	if in_range and can_open:
		if Input.is_action_just_pressed("ui_right_click"):
			get_tree().change_scene_to_file("res://potion.tscn")

