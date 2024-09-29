extends Node2D

@onready var player = $player/player
@onready var large_slime = $large_slime

func _ready():
	print(Global.num_enemies)

func _on_area_2d_body_entered(body):
	if body == player:
		Global.player_health = 0
		player.health = 0

func _on_enemy_walls_body_entered(body):
	if body.name == "large_slime":
		if body.chase:
			body.velocity.x = 0
		elif body.pace_left:
			body.pace_right = true
			body.pace_left = false
		else:
			body.pace_right = false
			body.pace_left = true
		
