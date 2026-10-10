extends Control

onready var menu: Control = get_node("Menu")

onready var button_container: VBoxContainer = get_node("Menu/ButtonContainer")

onready var continue_button: Button = button_container.get_node("Continue")

onready var skin_select: Control = get_node("SkinSelect")

func _ready() -> void:
	# Conectando os sinais
	for button in get_tree().get_nodes_in_group("button"):
		button.connect("pressed", self, "on_button_pressed", [button.name])
		button.connect("mouse_exited", self, "mouse_interaction", [button, "exited"])
		button.connect("mouse_entered", self, "mouse_interaction", [button, "entered"])
	
	has_save()
	
func on_button_pressed(button_name: String) -> void:
#	print(button_name)
	match button_name:
		"Play":
			button_container.hide()
			skin_select.show()
			pass
		"Continue":
			var _change_scene: bool = get_tree().change_scene("res://scenes/management/Level.tscn")
			pass
		"Quit":
			get_tree().quit()
			
		"BackButton":
			skin_select.hide()
			button_container.show()
			
		"Blue":
			send_skin_and_start_game("res://assets/player/char_blue.png")
			pass
		"Green":
			send_skin_and_start_game("res://assets/player/char_green.png")
			pass
		"Purple":
			send_skin_and_start_game("res://assets/player/char_purple.png")
			pass
		"Red":
			send_skin_and_start_game("res://assets/player/char_red.png")
			pass
			
	reset()
	
	
func mouse_interaction(button: Button, type: String) -> void:
	if button.disabled:
		return
		
	match type:
		"exited":
			button.modulate.a = 1.0
			pass
		"entered":
			button.modulate.a = 0.5
			pass
		
	
func reset() -> void:
	for button in get_tree().get_nodes_in_group("button"):
		mouse_interaction(button, "exited")
#	has_save()
		
func has_save() -> void:
	var file = File.new()
	if file.file_exists(data_management.save_path):
		continue_button.disabled = false
#		continue_button.modulate.a = 1.0
		return
		
	continue_button.modulate.a = 0.5
	
func send_skin_and_start_game(skin: String) -> void:
	data_management.data_dictionary.player_texture = skin
	var _change_scene: bool = get_tree().change_scene("res://scenes/management/Level.tscn")
	data_management.save_data()
	pass

