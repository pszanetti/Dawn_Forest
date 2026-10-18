extends Area2D


var player_ref: KinematicBody2D =null
var can_interact: bool = true

var dialog_list: Dictionary = {
	"name": "Merchant",
	"portrait": "res://assets/interface/dialog/merchant_portrait.png",
	"dialog": [
		"Hello adventure",
		"What do I would like to you ?"
		]
	}

onready var aux_animation: AnimationPlayer = get_node("DialogIcon/AuxAnimation")

func on_shop_body_entered(body):
	player_ref = body
	if can_interact:
		aux_animation.play("fade_in")
		


func on_shop_body_exited(_body):
	player_ref = null
	aux_animation.play("fade_out")
	
func _process(_delta: float) -> void:
	if (
		player_ref != null 
		and Input.is_action_just_pressed("interact") 
		and player_ref.is_on_floor()
		and can_interact
		):
#		print("Interação")
		interactable_action()
		can_interact = false
		
	
func interactable_action() -> void:
	get_tree().call_group("hud", "spawn_dialog", self, dialog_list)
	aux_animation.play("fade_out")
	player_ref.reset(true)

func on_dialog_finished() -> void:
	can_interact = true
	player_ref.reset(false)
	aux_animation.play("fade_in")
	pass

