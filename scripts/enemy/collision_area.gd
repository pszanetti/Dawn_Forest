extends Area2D

class_name CollisionArea

onready var timer: Timer = get_node("Timer")

export(int) var health
export(float) var invulnerability_timer

# Cria o link para acesso a dados do "Pai" -> KinemticBody EnemyTemplate
export(NodePath) onready var enemy = get_node(enemy) as KinematicBody2D


func on_collision_area_entered(area):
	# Se o pai da área de ataque for o Player
	if area.get_parent() is Player:
		# Vai para o pai da area, ou seja o Player e pega o node filho Stats
		var player_stats: Node = area.get_parent().get_node("Stats")
		var player_attack = player_stats.base_attack + player_stats.bonus_attack
		update_health(player_attack)
	elif area is FireSpell:     # -> Se foi atingido por um ataque mágico
		update_health(area.spell_damage)
		set_deferred("monitoring", false)
		timer.start(invulnerability_timer)
		
	
# Recebe o dano player_attack como damage
func update_health(damage: int) -> void:
	health -= damage
#	print("CollisionArea Health", health)
#	print("Ataque entrou dano ", damage)
	if health < 0:
		# Acessa a raiz e coloca como true sua variável caan_die
		enemy.can_die = true
		return # -> Sai da função
	enemy.can_hit = true



func on_timer_timeout():
	set_deferred("monitoring", true)
	pass # Replace with function body.
