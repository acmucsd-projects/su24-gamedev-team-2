extends Node

var player_position = Vector2()
var player_health: int
var player_direction_left: bool
var respawn = true

var enemy_position = Vector2()
var enemy_health: int
var enemy_direction_left: bool
var enemy_respawn: bool = true

var num_enemies: int = 1
var kill_all_enemies: bool = false
