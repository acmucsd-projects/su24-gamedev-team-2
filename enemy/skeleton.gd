extends CharacterBody2D

const DASH_ATTACK_SPEED = 200
var dash_chance: int
var can_dash = false
var dash_duration = 1

const SPEED = 50.0
var health = 20
var current_health = health
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var chase = false
var is_striking = false

@export var knockback_force : float = 700.0
var knockback_duration : float = 0.2
var is_knocked_back : bool = false
var knockback_direction : Vector2

var invincible = false
var invincibility_duration = 0.7

var pace_left = false
var pace_right = false

func _ready():
	if Global.enemy_respawn == false:
		self.queue_free()
	if Global.enemy_position:
		self.position = Global.enemy_position
	if Global.enemy_health:
		self.health = Global.enemy_health
		$SkeletonBar.value=self.health
	if Global.enemy_direction_left:
		$AnimatedSprite2D.flip_h = true
	get_node("AnimatedSprite2D").play("idle")
	
@onready var player = get_node("../../player/player")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if invincible:
		invincibility_duration -= delta
		if invincibility_duration <= 0:
			invincible = false
	
	if not invincible and abs(player.position - self.position) < Vector2(50,50) and player.is_striking:
		self.health -= 5
		invincibility()
	
	if health < current_health and health > 0:
		#velocity.x = 0
		get_node("AnimatedSprite2D").play("hurt")
		await get_node("AnimatedSprite2D").animation_finished
		current_health = health
		$SkeletonBar.value=current_health
		
	if is_knocked_back:
		velocity = knockback_direction.normalized() * knockback_force
		knockback_duration -= delta
		if knockback_duration <= 0:
			is_knocked_back = false
			velocity = Vector2.ZERO
	
	if health <= 0 or Global.kill_all_enemies :
		is_striking = false
		chase = false
		var player_health = player.health
		Global.enemy_respawn = false
		Global.enemy_health = 0
		$SkeletonBar.value=0
		get_node("AnimatedSprite2D").play("death")
		await get_node("AnimatedSprite2D").animation_finished
		self.queue_free()
		Global.num_enemies -= 1
		player.is_knocked_back = false
		player.health = player_health
		
	
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
		if dash_chance == 2 and can_dash and dash_duration > 0:
			dash_duration -= delta
			direction = (player.position - self.position).normalized()
			print(direction)
			velocity.x = direction.x * DASH_ATTACK_SPEED
		else:
			velocity.x = direction.x * SPEED
	else:
		if get_node("AnimatedSprite2D").animation != "strike" and get_node("AnimatedSprite2D").animation != "strike2" and get_node("AnimatedSprite2D").animation != "hurt":
			get_node("AnimatedSprite2D").play("idle")
		velocity.x = 0

	move_and_slide()
	
	Global.enemy_position = self.position
	if health > 0:
		Global.enemy_health = self.health
		$SkeletonBar.value=current_health

func _on_area_2d_player_detection_body_entered(body):
	if body.name == "player":
		chase = true
		can_dash = true
		dash_duration = 1
		dash_chance = randi_range(1, 2)
		get_node("AnimatedSprite2D").play("walk")

func _on_area_2d_player_detection_body_exited(body):
	if body.name == "player":
		chase = false
		can_dash = false
		get_node("AnimatedSprite2D").play("idle")

func _on_area_2d_strike_body_entered(body):
	if body.name == "player":
		is_striking = true
		if dash_chance == 2:
			while is_striking:
				body.health -= 10
		else:
			chase = false
			can_dash = false
			while is_striking:
				velocity.x = 0
				var light_or_heavy = randi_range(1, 5)
				if light_or_heavy == 5:
					get_node("AnimatedSprite2D").play("strike")
					await get_node("AnimatedSprite2D").animation_finished
					body.health -= 10
					var direction = (body.position - position).normalized()
					body.call("apply_knockback", direction * knockback_force)
					get_node("AnimatedSprite2D").play("strike2")
					await get_node("AnimatedSprite2D").animation_finished
				else:
					get_node("AnimatedSprite2D").play("strike")
					await get_node("AnimatedSprite2D").animation_finished
					body.health -= 5
					var direction = (body.position - position).normalized()
					body.call("apply_knockback", direction * knockback_force)
					get_node("AnimatedSprite2D").play("strike2")
					await get_node("AnimatedSprite2D").animation_finished
				if body.health <= 0:
					is_striking = false

func _on_area_2d_strike_body_exited(body):
	if body.name == "player":
		is_striking = false
		chase = true
		can_dash = true
		dash_duration = 1
		dash_chance = randi_range(1, 2)
		get_node("AnimatedSprite2D").play("walk")
		
func apply_knockback(direction: Vector2) -> void:
	is_knocked_back = true
	knockback_direction = direction
	knockback_duration = 0.2  # Reset the duration
	
func invincibility() -> void:
	invincible = true
	invincibility_duration = 0.7
