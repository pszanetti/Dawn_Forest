extends Control

class_name StatsContainer

onready var animation: AnimationPlayer = get_node("Animation")

onready var left_container: TextureRect = get_node("LeftContainer")

onready var right_container: TextureRect = get_node("RightContainer")

var is_visible: bool = false


func update_stats(stats_list: Array, bonus_stats_list: Array) -> void:
	left_container.update_stats(stats_list, bonus_stats_list)
	
	
func update_bonus_stats(bonus_dic: Dictionary, state: bool) -> void:
	right_container.update_bonus_stats(bonus_dic, state)
	pass
func reset() -> void:
#	left_container.reset()
#	right_container.reset()
	pass
func update_available_points() -> void:
	# Chamado sempre quando passar de nivel + 5 sempre quando passa de nivel
	right_container.update_available_points(5)
	pass
