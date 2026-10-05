extends TextureRect

class_name StatsRightContainer

onready var vcontainer: VBoxContainer = get_node("VContainer")

var stats_points: int = 0

export(NodePath) onready var points_info = get_node(points_info) as TextureRect

func _ready() -> void:
	var file = File.new()
	if file.file_exists(data_management.save_path):
		data_management.load_data()
		stats_points = data_management.data_dictionary.available_points
	
	points_info.update_text_value(str(stats_points))
	for children in vcontainer.get_children():
		
		var button: TextureButton = children.get_node("Plus")
#		print(button.name)
		# o var _etc é só para tirar os warrnings em amarelo
		var _pressed: bool = button.connect("pressed", self, "verify_stats", [children.name])
		var _exited: bool = button.connect("mouse_exited", self, "mouse_interaction", ["exited", button])
		var _entered: bool = button.connect("mouse_entered", self, "mouse_interaction", ["entered", button])
		
	
func mouse_interaction(type: String, button) -> void:
	match type:
		"exited":
			button.modulate.a = 1.0
			points_info.play_animation("hide_container")
		"entered":
			button.modulate.a = 0.5
			points_info.play_animation("show_container")

func verify_stats(stat:String) -> void:
	match stat:
		"HealthContainer":
			apply_weight(1, "Health")
			
		"ManaContainer":
			apply_weight(1, "Mana")
			
		"AttackContainer":
			apply_weight(3, "Attack")
			
		"MagicAttackContainer":
			apply_weight(3, "Magic Attack")
			
		"DefenseContainer":
			apply_weight(5, "Defense")
			
	
func apply_weight(weight: int, stat: String) -> void:
	if stats_points >= weight:
		stats_points -= weight
		# Exibindo os pontos disponíveis
		points_info.update_text_value(str(stats_points))
		# Enviar os atributos evoluídos para o sistema de stats do persanagem
		get_tree().call_group("player_stats", "update_stats", stat)
		
		# Salvando os pontos disponíveis
		data_management.data_dictionary.available_points = stats_points
		data_management.save_data()
	
func reset() -> void:
	for children in vcontainer.get_children():
		var button: TextureButton = children.get_node("Plus")
		if button.modulate.a != 1.0:
			button.modulate.a = 1.0
			points_info.play_animation("hide_container")
			
func update_available_points(value: int) -> void:
	stats_points += value
	points_info.update_text_value(str(stats_points))
	data_management.data_dictionary.available_points = stats_points
	data_management.save_data()
	
	
