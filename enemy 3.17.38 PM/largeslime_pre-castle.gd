extends CharacterBody2D

@onready var player = $"../player"

const SPEED = 50.0
var health = 20
var current_health = health
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var chase = false
var is_striking = false

@export var knockback_force : float = 500.0
var knockback_duration : float = 0.2
var is_knocked_back : bool = false
var knockback_direction : Vector2

var invincible = false
var invincibility_duration = 0.7

var pace_left = false
var pace_right = true

const DASH_ATTACK_SPEED = 200
var dash_chance: int
var can_dash = false
var is_dashing = false
var dash_duration = 2

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if invincible:
		invincibility_duration -= delta
		if invincibility_duration <= 0:
			invincible = false
	
	if not invincible and abs(player.position - self.position) < Vector2(50,50) and player.is_striking:
		self.health -= 3
		invincibility()
	
	if health < current_health and health > 0:
		get_node("AnimatedSprite2D").play("hurt")
		await get_node("AnimatedSprite2D").animation_finished
		current_health = health
		$LargeSlimeBar.value=current_health
		
	if is_knocked_back:
		velocity = knockback_direction.normalized() * knockback_force
		knockback_duration -= delta
		if knockback_duration <= 0:
			is_knocked_back = false
			velocity = Vector2.ZERO
	
	if health <= 0:
		Global.enemy_respawn = false
		Global.enemy_health = 0
		is_striking = false
		chase = false
		var player_health = player.health
		$LargeSlimeBar.value=0
		get_node("AnimatedSprite2D").play("death")
		await get_node("AnimatedSprite2D").animation_finished
		self.queue_free()
		Global.num_enemies -= 1
		if Global.num_enemies > 0:
			Global.kill_all_enemies = true
		player.is_knocked_back = false
		player.health = player_health
		level_end_scene()
	
	if chase:
		if get_node("AnimatedSprite2D").animation != "attack_basic" and \
		get_node("AnimatedSprite2D").animation != "attack_heavy" and \
		get_node("AnimatedSprite2D").animation != "attack_dash" and \
		get_node("AnimatedSprite2D").animation != "hurt":
			get_node("AnimatedSprite2D").play("walk")
		var direction = (player.position - self.position).normalized()
		if direction.x > 0:
			get_node("AnimatedSprite2D").flip_h = true
			Global.enemy_direction_left = true
		if direction.x < 0:
			get_node("AnimatedSprite2D").flip_h = false
			Global.enemy_direction_left = false
		if dash_chance == 2 and can_dash and dash_duration > 0:
			dash_duration -= delta
			is_dashing = true
			get_node("AnimatedSprite2D").play("attack_dash")
			velocity.x = direction.x * DASH_ATTACK_SPEED
		else:
			velocity.x = direction.x * SPEED
			get_node("AnimatedSprite2D").play("walk")
	elif pace_left:
		if get_node("AnimatedSprite2D").animation != "attack_basic" and \
		get_node("AnimatedSprite2D").animation != "attack_heavy" and \
		get_node("AnimatedSprite2D").animation != "attack_dash" and \
		get_node("AnimatedSprite2D").animation != "hurt":
			get_node("AnimatedSprite2D").play("walk")
		get_node("AnimatedSprite2D").flip_h = false
		Global.enemy_direction_left = false
		velocity.x = -SPEED
	elif pace_right:
		if get_node("AnimatedSprite2D").animation != "attack_basic" and \
		get_node("AnimatedSprite2D").animation != "attack_heavy" and \
		get_node("AnimatedSprite2D").animation != "attack_dash" and \
		get_node("AnimatedSprite2D").animation != "hurt":
			get_node("AnimatedSprite2D").play("walk")
		get_node("AnimatedSprite2D").flip_h = true
		Global.enemy_direction_left = true
		velocity.x = SPEED

	move_and_slide()
	
	if health > 0:
		Global.enemy_health = self.health
		$LargeSlimeBar.value=current_health

func _on_area_2d_player_detection_body_entered(body):
	if body.name == "player":
		chase = true
		pace_left = false
		pace_right = false
		can_dash = true
		dash_duration = 2
		dash_chance = randi_range(1, 2)
		get_node("AnimatedSprite2D").play("walk")

func _on_area_2d_player_detection_body_exited(body):
	if body.name == "player":
		chase = false
		pace_left = true
		can_dash = false
		get_node("AnimatedSprite2D").play("walk")

func _on_area_2d_strike_body_entered(body):
	if body.name == "player" and body.health > 0:
		is_striking = true
		if is_striking and can_dash and is_dashing:
			body.health -= 7
			var direction = (body.position - position).normalized()
			body.call("apply_knockback", direction * knockback_force)
			can_dash = false
			is_dashing = false
			if body.health <= 0:
				is_striking = false
		if is_striking:
			can_dash = false
			chase = false
			while is_striking:
				velocity.x = 0
				var light_or_heavy = randi_range(1, 5)
				if light_or_heavy == 5:
					get_node("AnimatedSprite2D").play("attack_heavy")
					await get_node("AnimatedSprite2D").animation_finished
					body.health -= 10
					var direction = (body.position - position).normalized()
					body.call("apply_knockback", direction * knockback_force)
				else:
					get_node("AnimatedSprite2D").play("attack_basic")
					await get_node("AnimatedSprite2D").animation_finished
					body.health -= 5
					var direction = (body.position - position).normalized()
					body.call("apply_knockback", direction * knockback_force)
				if body.health <= 0:
					is_striking = false

func _on_area_2d_strike_body_exited(body):
	if body.name == "player":
		is_striking = false
		chase = true
		can_dash = true
		dash_duration = 2
		dash_chance = randi_range(1, 2)
		get_node("AnimatedSprite2D").play("walk")
		
func apply_knockback(direction: Vector2) -> void:
	is_knocked_back = true
	knockback_direction = direction
	knockback_duration = 0.2  # Reset the duration
	
func invincibility() -> void:
	invincible = true
	invincibility_duration = 0.7

func level_end_scene() -> void:
	if get_tree(): #and get_node("AnimatedSprite2D").animation != "death":
		get_tree().change_scene_to_file("res://level_end.tscn")
