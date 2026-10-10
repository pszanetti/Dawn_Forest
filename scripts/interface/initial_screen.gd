extends Control

onready var menu: Control = get_node("Menu")

onready var button_container: VBoxContainer = get_node("Menu/ButtonContainer")


func _ready() -> void:
	# Conectando os sinais
	for button in get_tree().get_nodes_in_group("button"):
		button.connect("pressed", self, "on_button_pressed", [button.name])
		button.connect("mouse_exited", self, "mouse_interaction", [button, "exited"])
		button.connect("mouse_entered", self, "mouse_interaction", [button, "entered"])
	
func on_button_pressed(button_name: String) -> void:
#	print(button_name)
	match button_name:
		"Play":
			var _change_scene: bool = get_tree().change_scene("res://scenes/management/Level.tscn")
			pass
		"Continue":
			
			pass
		"Quit":
			get_tree().quit()
	pass
func mouse_interaction(button: Button, type: String) -> void:
	match type:
		"exited":
			button.modulate.a = 1.0
			pass
		"entered":
			button.modulate.a = 0.5
			pass
		
	pass
