extends CharacterBody2D

#const GRAVITY=10
#const JUMP_POWER=-300 #negative direction is up
#var velocity=Vector2(0,0)#takes x and y direction

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var jumps=0
var max_jumps=2


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		jumps=0
	
	#double jump
	if Input.is_action_just_pressed("ui_accept") and jumps < max_jumps:
		velocity.y += JUMP_VELOCITY #I think something wrong happens here
		jumps += 1
	
	

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		#velocity.x -= SPEED
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	## left and right
	#if Input.is_action_pressed("ui_left"):
		#velocity.x -= SPEED
	#if Input.is_action_pressed("ui_right"):
		#velocity.x += SPEED

	move_and_slide()


func _on_spike_body_entered(body):
	if body.name == "Player":
		$ProgressBar.value -= 10
