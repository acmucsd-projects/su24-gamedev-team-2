extends CharacterBody2D

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
	if Global.enemy_health:
		self.health = Global.enemy_health
		$SmallSlimeBar.value=self.health
	if Global.enemy_direction_left:
		$AnimatedSprite2D.flip_h = false
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
		get_node("AnimatedSprite2D").play("hurt")
		await get_node("AnimatedSprite2D").animation_finished
		current_health = health
		$SmallSlimeBar.value=current_health
		
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
		$SmallSlimeBar.value=0
		get_node("AnimatedSprite2D").play("death")
		await get_node("AnimatedSprite2D").animation_finished
		self.queue_free()
		Global.num_enemies -= 1
		player.is_knocked_back = false
		player.health = player_health
	
	if chase:
		if get_node("AnimatedSprite2D").animation != "attack_basic" and \
		get_node("AnimatedSprite2D").animation != "hurt":
			get_node("AnimatedSprite2D").play("walk")
		var direction = (player.position - self.position).normalized()
		if direction.x > 0:
			get_node("AnimatedSprite2D").flip_h = true
			Global.enemy_direction_left = true
		if direction.x < 0:
			get_node("AnimatedSprite2D").flip_h = false
			Global.enemy_direction_left = false
		velocity.x = direction.x * SPEED
	else:
		if get_node("AnimatedSprite2D").animation != "attack_basic" and \
		get_node("AnimatedSprite2D").animation != "hurt":
			get_node("AnimatedSprite2D").play("idle")
		velocity.x = 0

	move_and_slide()
	
	if health > 0:
		Global.enemy_health = self.health
		$SmallSlimeBar.value=current_health

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
		self.is_striking = true
		chase = false
		while self.is_striking: 
			velocity.x = 0
			get_node("AnimatedSprite2D").play("attack_basic")
			await get_node("AnimatedSprite2D").animation_finished
			if not body.invincible:
				body.health -= 5
				var direction = (body.position - position).normalized()
				body.call("apply_knockback", direction * knockback_force)
			if body.health <= 0:
				self.is_striking = false

func _on_area_2d_strike_body_exited(body):
	if body.name == "player":
		is_striking = false
		chase = true
		get_node("AnimatedSprite2D").play("walk")
		
func apply_knockback(direction: Vector2) -> void:
	is_knocked_back = true
	knockback_direction = direction
	knockback_duration = 0.2  # Reset the duration
	
func invincibility() -> void:
	invincible = true
	invincibility_duration = 0.7
