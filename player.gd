#extends CharacterBody2D
#
#@export var SPEED: int = 150
#@export var JUMP_FORCE: int = -300
#@export var GRAVITY: int = 900
#@export var DASH_SPEED = 600
#var JUMP_COUNT = 0
#var MAX_JUMP = 2
#var DOUBLE_TAP_R = false
#var DTR = false
#var DTL = false
#
#
#var DASHING = false
#var CAN_DASH = true
#
#func _physics_process(delta):
	#var direction = Input.get_axis("move_left", "move_right")
	#if not is_on_floor():
		#velocity.y += GRAVITY * delta
	#if is_on_floor():
		#JUMP_COUNT = 0
		#
	#if Input.is_action_just_pressed("jump") and JUMP_COUNT < MAX_JUMP:
		#$AnimatedSprite2D.play('jump')
		#velocity.y = JUMP_FORCE
		#JUMP_COUNT += 1
		#
	#if direction:
		#velocity.x = direction * SPEED
		#$AnimatedSprite2D.play('run')
		#$AnimatedSprite2D.flip_h = (direction < 0)
		#if DASHING:
			#velocity.x = direction * DASH_SPEED
		#else: 
			#velocity.x = direction * SPEED
	#else:
		#velocity.x = 0
		#$AnimatedSprite2D.play('idle')
	#
#
	#if Input.is_action_just_pressed("dash") and CAN_DASH:
		#DASHING = true
		#CAN_DASH = false
		#$dash_duration.start()
		#$dash_again.start()
#
	## Move the player
	#move_and_slide()
#
#func _on_dash_again_timeout():
	#CAN_DASH = true
#
#
#func _on_dash_duration_timeout():
	#DASHING = false
extends CharacterBody2D

@export var SPEED: int = 150
@export var JUMP_FORCE: int = -300
@export var GRAVITY: int = 900
@export var DASH_SPEED = 600
var JUMP_COUNT = 0
var MAX_JUMP = 2
var DOUBLE_TAP_R = false
var DTR = false
var DTL = false


var DASHING = false
var CAN_DASH = true

func _physics_process(delta):
	var direction = Input.get_axis("move_left", "move_right")
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	if is_on_floor():
		JUMP_COUNT = 0
		
	if Input.is_action_just_pressed("jump") and JUMP_COUNT < MAX_JUMP:
		$AnimatedSprite2D.play('jump')
		velocity.y = JUMP_FORCE
		JUMP_COUNT += 1
		
	if direction:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.play('run')
		$AnimatedSprite2D.flip_h = (direction < 0)
		if DASHING:
			velocity.x = direction * DASH_SPEED
		else: 
			velocity.x = direction * SPEED
	else:
		#velocity.x = 0
		velocity.x = lerp(velocity.x,0.0,0.1)
		$AnimatedSprite2D.play('idle')
	#if Input.is_action_just_pressed("left"):
		#if DTL == true:
			#sprinting = true
	#if Input.is_action_just_pressed("right"):
		

	if Input.is_action_just_pressed("dash") and CAN_DASH:
		DASHING = true
		CAN_DASH = false
		$dash_duration.start()
		$dash_again.start()

	# Move the player
	move_and_slide()

func _on_dash_again_timeout():
	CAN_DASH = true


func _on_dash_duration_timeout():
	DASHING = false
	DTL = false
	DTR = false
