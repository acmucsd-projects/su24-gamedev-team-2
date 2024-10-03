extends CharacterBody2D

var is_chatting = false
var player
var player_in_chat_zone = false
var chat_timeout = false


func _process(delta):
	if !is_chatting:
		$AnimatedSprite2D.play("idle")
	elif is_chatting:
		$AnimatedSprite2D.play("talk")

	
	if Input.is_action_just_pressed("ui_chat") and player_in_chat_zone:
		is_chatting = true
		chat_timeout = false 
		$Timer.stop()  

	
	if chat_timeout:
		is_chatting = false
		chat_timeout = false  
		
func _on_chatdetection_body_entered(body):
	if body.name == "player":
		player_in_chat_zone = true
		chat_timeout = false  
		$Timer.stop()  

func _on_chatdetection_body_exited(body):
	if body.name == "player":
		player_in_chat_zone = false
		$Timer.start()  

func _on_timer_timeout():
	if not player_in_chat_zone: 
		chat_timeout = true 

