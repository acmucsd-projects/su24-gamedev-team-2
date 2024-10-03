extends CharacterBody2D

var health = 100
var current_health = health
const SPEED = 200
const STRIKE_SPEED = 0.0
const JUMP_VELOCITY = -400.0
const DASH_SPEED = 600
var JUMP_COUNT = 0
var MAX_JUMP = 2

var DASHING = false
var CAN_DASH = true

var knockback_force : float = 300.0
var knockback_duration : float = 0.2
var is_knocked_back : bool = false
var knockback_direction : Vector2

var invincible = false
var invincibility_duration = 0.7

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_striking = false  # Flag to track if strike animation is active

@onready var anim = $AnimationPlayer
@onready var small_slime = $"../small slime"
@onready var large_slime = $"../large slime"

func _ready() -> void:
	if Global.player_position:
		self.position = Global.player_position
	if Global.player_health:
		self.health = Global.player_health
	if Global.player_direction_left:
		$AnimatedSprite2D.flip_h = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Global.respawn:
		anim.play("respawn")
		await anim.animation_finished
		Global.respawn = false
	
	if Input.is_action_just_pressed("ui_space") and JUMP_COUNT < MAX_JUMP:
		anim.play("jump")
		velocity.y = JUMP_VELOCITY
		JUMP_COUNT += 1
		
	if is_on_floor():
		JUMP_COUNT = 0
		
	if health <= 0:
		Global.player_health = 0
		$PlayerBar.value=0
		anim.play("death")
		await anim.animation_finished
		respawn_scene()
		
	if invincible:
		invincibility_duration -= delta
		if invincibility_duration <= 0:
			invincible = false
		
	if health < current_health and health > 0:
		anim.play("hurt")
		await anim.animation_finished
		invincibility()
		current_health = health
		$PlayerBar.value=health
		
	if is_knocked_back:
		velocity = knockback_direction.normalized() * knockback_force
		knockback_duration -= delta
		if knockback_duration <= 0:
			is_knocked_back = false
			velocity = Vector2.ZERO
			
	if Input.is_action_just_pressed("ui_left_click"):
		if anim.current_animation != "strike":
			anim.play("strike")
			is_striking = true  # Set flag to prevent other animations

			if Global.enemy_health > 0 and self.health>0:
				var distance = large_slime.position - self.position
				if abs(distance.x) <= 50:
					var dir = (large_slime.position - position).normalized()
					large_slime.call("apply_knockback", dir * knockback_force)
			else: 
				is_striking = false
		
	if Input.is_action_just_pressed("ui_space") and JUMP_COUNT < MAX_JUMP:
		anim.play('jump')
		velocity.y = JUMP_VELOCITY
		JUMP_COUNT += 1
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction == 1:
		$AnimatedSprite2D.flip_h = false
		Global.player_direction_left = false
	if direction == -1:
		$AnimatedSprite2D.flip_h = true
		Global.player_direction_left = true
	
	if direction:
		if DASHING:
			velocity.x = direction * DASH_SPEED
		elif is_striking and is_on_floor():
			velocity.x = direction * STRIKE_SPEED
		else:
			velocity.x = direction * SPEED
		if velocity.y == 0 and anim.current_animation != "strike" and anim.current_animation != "hurt" and anim.current_animation != "dash":
			anim.play("run")
		
	else:
		if is_striking and is_on_floor():
			velocity.x = move_toward(velocity.x, 0, STRIKE_SPEED)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0 and anim.current_animation != "strike" and anim.current_animation != "hurt":
			anim.play("idle")
	
	Global.player_position = self.position
	if health > 0:
		Global.player_health = health
		$PlayerBar.value=health
	
	if is_striking and anim.current_animation != "strike":
		is_striking = false
		
	if Input.is_action_just_pressed("ui_shift") and CAN_DASH:
		DASHING = true
		CAN_DASH = false
		anim.play("dash")
		$dash_duration.start()
		$dash_again.start()
	move_and_slide()

func respawn_scene() -> void:
	if get_tree() and anim.current_animation != "death":
		get_tree().change_scene_to_file("res://respawn.tscn")

func _on_dash_duration_timeout():
	DASHING = false
	
func _on_dash_again_timeout():
	CAN_DASH = true

func apply_knockback(direction: Vector2) -> void:
	is_knocked_back = true
	knockback_direction = direction
	knockback_duration = 0.2  # Reset the duration
	
func invincibility() -> void:
	invincible = true
	invincibility_duration = 0.7
