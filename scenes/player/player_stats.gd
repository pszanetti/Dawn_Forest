extends Node

class_name PlayerStats

var shielding: bool = false

# Valores iniciais que tendem a aumentar de acordo com a experiência
var base_health: int = 15
var base_mana: int = 10
var base_attack: int = 1
var base_magic_attack: int = 3
var base_defense: int = 1

# Valores de bonus ganhos
var bonus_health: int = 0
var bonus_mana: int = 0
var bonus_attack: int = 0
var bonus_magic_attack: int = 0
var bonus_defense: int = 0


# Variáveis para armazenar o valor atual durante o jogo
var current_health: int
var current_mana: int

# Guarda o valor da experiência adquirida pelo personagem
var current_exp: int = 0

# Soma da mana base + a mana bonus
var max_mana: int
# Soma da health base + a health bonus
var max_health: int

# Level e informações do nível do personagem
var level: int = 1
# Níveis para passar de level
var level_dict: Dictionary = {
	"1": 25,
	"2": 33,
	"3": 49,
	"4": 66,
	"5": 93,
	"6": 135,
	"7": 186,
	"8": 251,
	"9": 356
	}
	
# Guarda o acesso ao node Player na variável player para acessar suas variáveis e funções
export(NodePath) onready var player = get_node(player) as KinematicBody2D
# Guardar o acesso a area de colisão que irá sofrer dano
export(NodePath) onready var collision_area = get_node(collision_area) as Area2D
# Guarda o acesso ao FloatingText
export(PackedScene) var floating_text

# Carregando o Timer de invencibilidade
onready var invencibility_timer = get_node("InvencibilityTimer")

func _ready() -> void:	
	var file: File = File.new()
	if file.file_exists(data_management.save_path):
		data_management.load_data()
		# Le a experiencia exp e o level 
		level = data_management.data_dictionary.current_level
		current_exp = data_management.data_dictionary.current_exp
		# Update Mana e Health
		update_stats_with_serialized_data()
		# Le a mana e a vida (health) salvas 
		current_mana = data_management.data_dictionary.current_mana
		current_health = data_management.data_dictionary.current_health
		
		get_tree().call_group("bar_container", "init_bar", max_health, max_mana, level_dict[str(level)])
		get_tree().call_group("bar_container", "reset_exp_bar", level_dict[str(level)], current_exp)
		
		get_tree().call_group("bar_container", "update_bar", "ManaBar", current_mana)
		get_tree().call_group("bar_container", "update_bar", "HealthBar", current_health)
		
	update_stats_hud()
	
func update_stats_with_serialized_data() -> void:
	var base_stats: Array = data_management.data_dictionary.base_stats
	base_health = base_stats[0]
	base_mana = base_stats[1]
	
	max_health = base_health + bonus_health
	max_mana = base_mana + bonus_mana
	print(base_stats)
	
	
func update_stats(stat: String) -> void:
	match stat:
		"Attack":
			base_attack += 1
		"Mana":
			max_mana += 1
			base_mana += 1
			current_mana += 1
			
			get_tree().call_group("bar_container", "increase_max_value", "Mana", max_mana, current_mana)
			
		"Health":
			max_health += 1
			base_health += 1
			current_health += 1
			get_tree().call_group("bar_container", "increase_max_value", "Health", max_health, current_health)
		# Nome igual ao StatsContainer
		"Magic Attack":
			base_magic_attack += 1
			
		"Defense":
			base_defense += 1
	update_stats_hud()
	
func update_bonus_stats(stat: String, value: int, reset: bool) -> void:
	match stat:
		"Health":
			if reset == true:
				bonus_health -= value
			if reset == false:
				bonus_health += value
			max_health = base_health + bonus_health
			# Chamando o Bar container
			get_tree().call_group("bar_container", 
				"increase_max_value", 
				"Health", 
				max_health, 
				current_health)
			
		"Mana":
			if reset == true:
				bonus_mana -= value
			if reset == false:
				bonus_mana += value
			max_mana = base_mana + bonus_mana
			# Chamando o Bar container
			get_tree().call_group("bar_container", 
				"increase_max_value", 
				"Mana", 
				max_mana, 
				current_mana)
			
		"Attack":
			if reset == true:
				bonus_attack -= value
			if reset == false:
				bonus_attack += value
			
		"Magic Attack":
			if reset == true:
				bonus_magic_attack -= value
			if reset == false:
				bonus_magic_attack += value
			
		"Defense":
			if reset == true:
				bonus_defense -= value
			if reset == false:
				bonus_defense += value
			
	update_stats_hud()
	
func update_stats_hud() -> void:
	get_tree().call_group(
		"stats_hud", 
		"update_stats",[
			base_health,
			base_mana,
			base_attack,
			base_magic_attack,
			base_defense
			],
				[
				bonus_health,
				bonus_mana,
				bonus_attack,
				bonus_magic_attack,
				bonus_defense
				]
		)
	data_management.data_dictionary.base_stats = [
		base_health,
		base_mana,
		base_attack,
		base_magic_attack,
		base_defense
		]
	data_management.save_data()
		
	if current_health > max_health:
		current_health = max_health
	if current_mana > max_mana:
		current_mana = max_mana
	

# Atualizando a experiencia
func update_exp(value: int) -> void:
	current_exp += value
	# Spawnando o texto
	spawn_floating_text("+", "Exp", value)
	# Acessando a função init_bar e enviando os valores
	get_tree().call_group("bar_container", "update_bar", "ExpBar", current_exp)
	
	if current_exp >= level_dict[str(level)] and level < 9:
		# Sobra ou resto da experiência
		var lefover: int = current_exp - level_dict[str(level)]
		current_exp = lefover
		# Incrementando o level do personagem
		on_level_up()
		level += 1
		# Salvando dos dados
		data_management.data_dictionary.current_level = level
		
		# Checando se chegou no nível máximo sendo o level 9 o máximo no level_dict
	elif current_exp >= level_dict[str(level)] and level == 9: 
		current_exp = level_dict[str(level)]
		
	# Salvando os dados
	data_management.data_dictionary.current_exp = current_exp
	data_management.save_data()
	
	
func on_level_up() -> void:
	current_health = base_health + bonus_health
	current_mana = base_mana + bonus_mana
	# Atualizando o valor (points)
	get_tree().call_group("stats_hud", "update_available_points")
	
	get_tree().call_group("bar_container", "update_bar", "ManaBar", current_mana)
	get_tree().call_group("bar_container", "update_bar", "HealthBar", current_health)
	# Dar uma pausa para colocar os novos valores na barra de experiência
	yield(get_tree().create_timer(0.2), "timeout")
	# Aguarda a finalização do timer para seguir para a linha abaixo
	get_tree().call_group("bar_container", "reset_exp_bar", level_dict[str(level)], current_exp)
	
func update_health(type: String, value: int) -> void:
	match type:
		"Increase":
			current_health += value
			spawn_floating_text("+", "Heal", value)
			if current_health >= max_health:
				current_health = max_health
		"Decrease":
#			print("Entrou !? ", current_health)
			verify_shield(value)
			if current_health <= 0:
				player.dead = true
				# Chama a animação de morte
			else:
				player.on_hit = true
				player.attacking = false
				# Chama aniamação de dano e bloqueia o ataque
	# Salva a vida (health) atual
	data_management.data_dictionary.current_health = current_health
	data_management.save_data()
	# Atualiza o bar - barra de vida
	get_tree().call_group("bar_container", "update_bar", "HealthBar", current_health)
	
	
func verify_shield(value: int) -> void:
	if shielding:
		if (base_defense + bonus_defense) >= value:
			return # Sai sa função verify_shield
		#print(" acabou a defesa")
		var damage = abs ((base_defense + bonus_defense) - value) 
		spawn_floating_text("-", "Damage", damage)
		current_health -= damage
#		print("Entrou !? ", current_health)
		
	else:
		current_health -= value
		spawn_floating_text("-", "Damage", value)
	
	
func update_mana(type: String, value: int) -> void:
	match type:
		"Increase":
			current_mana += value
			spawn_floating_text("+", "Mana", value)
			if current_mana >= max_mana:
				current_mana = max_mana
		"Decrease":
			current_mana -= value
			spawn_floating_text("-", "Mana", value)
			
	# Salva os dados de mana atual
	data_management.data_dictionary.current_mana = current_mana
	data_management.save_data()
	# Atualiza a barra de mana
	get_tree().call_group("bar_container", "update_bar", "ManaBar", current_mana)
# Função para teste de dano e morte
# Sempre que apertar "espaço" irá causar 5 de dano
#func _process(delta):
#	if Input.is_action_just_pressed("ui_select"):
#		update_health("Decrease", 5)
#	pass

			


func on_collision_area_entered(area):
#	print(area.name)
	if area.name =="EnemyAttackArea":
		# Cada inimigo dará um dano x (damage)
		update_health("Decrease", area.damage)
		# Desabilitando a area responsável por receber dano
		collision_area.set_deferred("monitoring", false)
		# Cada inimigo darṕá um tempo de recuperação (invencibility)
		invencibility_timer.start(area.invencibility_timer)
		
func on_invencibility_timer_timeout():
	# Retorna o monitoramento de dano
	collision_area.set_deferred("monitoring", true)
	
	
func spawn_floating_text(type_sign: String, type: String, value: int) -> void:
	var text: FloatText = floating_text.instance()
	text.rect_global_position = player.global_position
	text.type = type
	text.value = value
	text.type_sign = type_sign
	
	get_tree().root.call_deferred("add_child", text)
	
	pass

