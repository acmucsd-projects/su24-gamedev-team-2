extends Node2D

@export var enemy_scene: PackedScene # Drag and drop your Enemy.tscn here in the editor
@export var min_enemies: int = 1
@export var max_enemies: int = 3
@export var spawn_area_size: Vector2 = Vector2(1000, -100)  # Adjust to fit your needs

func _ready():
	spawn_random_enemies()

func spawn_random_enemies():
	# Get a random number of enemies to spawn
	var number_of_enemies = randi_range(min_enemies, max_enemies)
	Global.num_enemies += number_of_enemies

	for i in range(number_of_enemies):
		var enemy_instance = enemy_scene.instantiate()  # Create an instance of the enemy
		if enemy_instance:
			# Set a random position within the defined spawn area
			var random_x = randf_range(100, spawn_area_size.x)
			var random_y = randf_range(-600, spawn_area_size.y)
			enemy_instance.position = Vector2(random_x, random_y)
			# Add the enemy instance to the scene
			add_child(enemy_instance)
