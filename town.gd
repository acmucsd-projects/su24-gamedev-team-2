extends Area2D

var in_range = false
var can_open = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if in_range and can_open:
		if Input.is_action_just_pressed("ui_right_click"):
			var player = get_node("player/player")
			player.position = Vector2(140,437)


			get_tree().change_scene_to_file("res://town.tscn")


func _on_body_entered(body):
	if body.name == "player":
		in_range = true


func _on_body_exited(body):
	if body.name == "player":
		in_range = true
	

func _on_mouse_entered():
	can_open = true


func _on_mouse_exited():
	can_open = false
