extends CharacterBody2D

var health = 100
var current_health = health
const SPEED = 300.0
const STRIKE_SPEED = 0.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_striking = false  # Flag to track if strike animation is active

@onready var anim = $AnimationPlayer
@onready var skeleton = get_node("../../enemies/skeleton")

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
		
	if health <= 0:
		Global.player_health = 0
		anim.play("death")
		await anim.animation_finished
		respawn_scene()
		#self.queue_free()
		
	if health < current_health and health > 0:
		velocity.x = 0
		anim.play("hurt")
		await anim.animation_finished
		current_health = health
	
	if Input.is_action_just_pressed("ui_left_click"):
		if anim.current_animation != "strike":
			anim.play("strike")
			is_striking = true  # Set flag to prevent other animations
			var distance = skeleton.position - self.position
			if abs(distance.x) <= 30:
				skeleton.health -= 5
				if skeleton.health <= 0:
					is_striking = false
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_space") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("jump")
	
	if velocity.y > 0 and anim.current_animation != "strike" and anim.current_animation != "hurt":
		anim.play("fall")
	
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
		if is_striking and is_on_floor():
			velocity.x = direction * STRIKE_SPEED
		else:
			velocity.x = direction * SPEED
		if velocity.y == 0 and anim.current_animation != "strike" and anim.current_animation != "hurt":
			anim.play("run")
	else:
		if is_striking and is_on_floor():
			velocity.x = move_toward(velocity.x, 0, STRIKE_SPEED)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0 and anim.current_animation != "strike" and anim.current_animation != "hurt":
			anim.play("idle")
	
	move_and_slide()
	
	Global.player_position = self.position
	if health > 0:
		Global.player_health = health
	
	if is_striking and anim.current_animation != "strike":
		is_striking = false
		
func respawn_scene() -> void:
	if get_tree() and anim.current_animation != "death":
		get_tree().change_scene_to_file("res://respawn.tscn")
		return
	else:
		print(":(")
	

