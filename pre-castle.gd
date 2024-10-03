extends Node2D


# Called when the node enters the scene tree for the first time.

var in_checkpoint_range=false
var can_teleport_to_congrats = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if in_checkpoint_range==true and can_teleport_to_congrats==true:
		if Input.is_action_just_pressed("ui_right_click"):
			get_tree().change_scene_to_file("res://congrats.tscn")

func _on_checkpointfinal_mouse_shape_entered(shape_idx):
	if shape_idx.name=="player" and get_node("large slime").current_animation == "death":
		can_teleport_to_congrats=true


func _on_area_2d_body_entered(body):
	in_checkpoint_range=true
	
