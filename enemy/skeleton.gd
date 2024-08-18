extends CharacterBody2D

const SPEED = 50.0
var health = 20
var current_health = health
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var chase = false
var is_striking = false

func _ready():
	if Global.enemy_respawn == false:
		self.queue_free()
	if Global.enemy_position:
		self.position = Global.enemy_position
	if Global.enemy_health:
		self.health = Global.enemy_health
	if Global.enemy_direction_left:
		$AnimatedSprite2D.flip_h = true
	get_node("AnimatedSprite2D").play("idle")
	
@onready var player = get_node("../../player/player")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if health < current_health and health > 0:
		velocity.x = 0
		get_node("AnimatedSprite2D").play("hurt")
		await get_node("AnimatedSprite2D").animation_finished
		current_health = health
	
	if health <= 0:
		Global.enemy_respawn = false
		Global.enemy_health = 0
		get_node("AnimatedSprite2D").play("death")
		await get_node("AnimatedSprite2D").animation_finished
		self.queue_free()
	
	if chase:
		if get_node("AnimatedSprite2D").animation != "strike" and get_node("AnimatedSprite2D").animation != "strike2" and get_node("AnimatedSprite2D").animation != "hurt":
			get_node("AnimatedSprite2D").play("walk")
		var direction = (player.position - self.position).normalized()
		if direction.x > 0:
			get_node("AnimatedSprite2D").flip_h = false
			Global.enemy_direction_left = false
		if direction.x < 0:
			get_node("AnimatedSprite2D").flip_h = true
			Global.enemy_direction_left = true
		velocity.x = direction.x * SPEED
	else:
		if get_node("AnimatedSprite2D").animation != "strike" and get_node("AnimatedSprite2D").animation != "strike2" and get_node("AnimatedSprite2D").animation != "hurt":
			get_node("AnimatedSprite2D").play("idle")
		velocity.x = 0

	move_and_slide()
	
	Global.enemy_position = self.position
	if health > 0:
		Global.enemy_health = self.health

func _on_area_2d_player_detection_body_entered(body):
	if body.name == "player":
		chase = true
		get_node("AnimatedSprite2D").play("walk")

func _on_area_2d_player_detection_body_exited(body):
	if body.name == "player":
		chase = false
		get_node("AnimatedSprite2D").play("idle")

func _on_area_2d_strike_body_entered(body):
	if body.name == "player":
		is_striking = true
		chase = false
		while is_striking:
			velocity.x = 0
			get_node("AnimatedSprite2D").play("strike")
			await get_node("AnimatedSprite2D").animation_finished
			body.health -= 5
			get_node("AnimatedSprite2D").play("strike2")
			await get_node("AnimatedSprite2D").animation_finished
			if body.health <= 0:
				is_striking = false

func _on_area_2d_strike_body_exited(body):
	if body.name == "player":
		is_striking = false
		chase = true
		get_node("AnimatedSprite2D").play("walk")
