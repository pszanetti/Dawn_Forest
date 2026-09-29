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
#			stats_info.play_animation("hide_container")
			pass
		
func update_stats_info_container(stats: String) -> void:
#	stats_info.update_container(stats)
	pass


