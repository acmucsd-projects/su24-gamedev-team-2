#extends CharacterBody2D
#
#
#const SPEED = 300
#const JUMP_VELOCITY = -400.0
#
## Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#var player_chase = false
#var player = null
#
#func _physics_process(delta):
	## Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta
		#
#
	#
#
	#if player_chase:
		##velocity = (position - player.get_global_position()).normalized() * SPEED * delta
		#position += (player.position - position) /SPEED
		#$AnimatedSprite2D.play("walk")
		#if (player.position.x - position.x)<0:
			#$AnimatedSprite2D.flip_h = true
		#else:
			#$AnimatedSprite2D.flip_h = false
	#else:
		#velocity = lerp(velocity, Vector2.ZERO, 0.07)
		#$AnimatedSprite2D.play("Idle")
	#move_and_collide(velocity)
#
#
#func _on_area_2d_body_entered(body):
	#player = body
	#player_chase = true
#
#
#func _on_area_2d_body_exited(body):
	#player = null
	#player_chase = false
		#
