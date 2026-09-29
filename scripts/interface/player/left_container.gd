extends TextureRect


class_name StatsLeftContainer

onready var grid_container: GridContainer = get_node("GridContainer")

export(NodePath) onready var stats_info = get_node(stats_info) as TextureRect

func _ready() -> void:
	for container in grid_container.get_children():
		container.connecr("mouse_exit", self, "mouse_intaraction", ["exited", container])
		container.connecr("mouse_entered", self, "mouse_intaraction", ["entered", container])
	
func mouse_interaction(state: String, container: HBoxContainer) -> void:
	match state:
		"entered":
			container.modulate.a = 0.5
			match container.name:
				"HealthContainer":
					update_stats_info_container("health")
					pass
				"ManaContainer":
					update_stats_info_container("mana")
					pass
				"AttackContainer":
					update_stats_info_container("attack")
					pass
				"MagicAttackContainer":
					update_stats_info_container("magic_attack")
					pass
				"DefenseContainer":
					update_stats_info_container("defense")
					pass
			pass
		"exited":
			container.modulate.a = 1.0
			stats_info.play_animation("hide_container")
			pass
		
func update_stats_info_container(stats: String) -> void:
	stats_info.update_container(stats)
	pass


