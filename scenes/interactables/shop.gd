extends Area2D


var player_ref: KinematicBody2D =null
var can_interact: bool = true

onready var aux_animation: AnimationPlayer = get_node("DialogIcon/AuxAnimation")

func on_shop_body_entered(body):
	player_ref = body
	if can_interact:
		aux_animation.play("fade_in")
		
	pass # Replace with function body.


func on_shop_body_exited(body):
	player_ref = null
	aux_animation.play("fade_out")
	pass # Replace with function body.
