extends Area2D


var player_ref: KinematicBody2D =null

var can_interact: bool = true

func on_shop_body_entered(body):
	player_ref = body
	if can_interact:
		
		pass
	pass # Replace with function body.


func on_shop_body_exited(body):
	player_ref = null
	pass # Replace with function body.
