#2D top-down rpg
extends CharacterBody2D
@export var SPEED : int = 200
@export var DASH_SPEED = 900
var DASHING = false
var CAN_DASH = true


func _physics_process(delta):
	var motion = Vector2.ZERO
	if Input.is_action_pressed("dash") and CAN_DASH:
		DASHING = true
		CAN_DASH = false
		$dash_duration.start()
		$dash_again.start()
	if Input.is_action_pressed("move_right"):
		motion.x = SPEED
		$AnimatedSprite2D.play('walk')
		$AnimatedSprite2D.flip_h = false
	elif Input.is_action_pressed("move_left"):
		motion.x = -SPEED
		$AnimatedSprite2D.play('walk')
		$AnimatedSprite2D.flip_h = true
	elif Input.is_action_pressed("move_down"):
		motion.y = SPEED
		$AnimatedSprite2D.play('walk')
	elif Input.is_action_pressed("move_up"):
		motion.y = -SPEED
		$AnimatedSprite2D.play('walk')
	else:
		$AnimatedSprite2D.play('Idle')
	velocity = motion
	var direction_x = Input.get_axis("move_left","move_right")
	var direction_y = Input.get_axis("move_up","move_down")
	if direction_x or direction_y:
		if DASHING: 
			velocity.x = direction_x * DASH_SPEED
			velocity.y = direction_y * DASH_SPEED
		
	move_and_slide()

#stop dashing after # seconds
func _on_timer_timeout():
	DASHING = false


func _on_dash_again_timeout():
	CAN_DASH = true
