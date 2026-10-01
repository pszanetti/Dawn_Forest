extends TextureRect


class_name StatsLeftContainer

onready var grid_container: GridContainer = get_node("GridContainer")

export(NodePath) onready var stats_info = get_node(stats_info) as TextureRect

func _ready() -> void:
	for container in grid_container.get_children():
		default_bonus_value(container)
		# Conecta com as funções padrão mouse_exited e mouse_entered
		container.connect("mouse_exited", self, "mouse_interaction", ["exited", container])
		container.connect("mouse_entered", self, "mouse_interaction", ["entered", container])
	

func default_bonus_value(container: HBoxContainer) -> void:
	container.get_node("Bonus").text = ""
	pass
	
func mouse_interaction(state: String, container: HBoxContainer) -> void:
	match state:
		"entered":
			container.modulate.a = 0.5
			stats_info.play_animation("show_container")
			match container.name:
				"HealthContainer":
					update_stats_info_container("health")
					
				"ManaContainer":
					update_stats_info_container("mana")
					
				"AttackContainer":
					update_stats_info_container("attack")
					
				"MagicAttackContainer":
					update_stats_info_container("magic_attack")
					
				"DefenseContainer":
					update_stats_info_container("defense")
		"exited":
			print("Não entrou")
			container.modulate.a = 1.0
			stats_info.play_animation("hide_container")
			pass
		
func update_stats_info_container(stats: String) -> void:
	stats_info.update_container(stats)
	pass

func update_stats(stats_list: Array, bonus_stats_list: Array) -> void:
	for index in grid_container.get_child_count():
		# Pega dos 5 container as label Text
		var target_stat_text: Label = grid_container.get_child(index).get_node("Text")
		# Pega a Label de bonus que está dentro dos 5 containers do GridContainer
		var target_bonus_stat_text: Label = grid_container.get_child(index).get_node("Bonus")
		
		if bonus_stats_list[index] != 0:
			target_stat_text.txt = str(stats_list[index]) + " +"
			target_bonus_stat_text.text = str(bonus_stats_list[index])
			
		else:
			target_stat_text.txt = str(stats_list[index])
			target_bonus_stat_text.text = ""
			
func update_bonus_stats(bonus_dict: Dictionary, state: bool) -> void:
	for key in bonus_dict.keys():
		# Só não existe o método/função update_bonnus_stats em player_stats
		get_tree().call_group("player_stats", "update_bonus_stats", key, bonus_dict[key], state )
		
func reset() -> void:
	for container in grid_container.get_children():
		if container.modulate.a != 1.0:
			container.modulate.a = 1.0
			stats_info.play_animation("hide_container")
			pass
		pass
	pass

