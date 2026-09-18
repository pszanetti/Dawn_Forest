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

func _ready() -> void:
	current_health = base_health + bonus_health
	max_health = current_health
	
	current_mana = base_mana + bonus_mana
	max_mana = current_mana
	
# Atualizando a experiencia
func update_exp(value: int) -> void:
	current_exp += value
	if current_exp >= level_dict[str(level)] and level < 9:
		# Sobra ou resto da experiência
		var lefover: int = current_exp - level_dict[str(level)]
		current_exp = lefover
		# Incrementando o level do personagem
		on_level_up()
		level += 1
		# Checando se chegou no nível máximo sendo o level 9 o máximo no level_dict
	elif current_exp >= level_dict[str(level)] and level == 9: 
		current_exp = level_dict[str(level)]
		
		
func on_level_up() -> void:
	current_health = base_health + bonus_health
	current_mana = base_mana + bonus_mana
	
func update_health(type: String, value: int) -> void:
	match type:
		"Increase":
			current_health += value
			if current_health >= max_health:
				current_health = max_health
			pass
		"Decrease":
			verify_shield(value)
			if current_health <= 0:
				player.dead = true
				# Chama a animação de morte
			else:
				player.on_hit = true
				player.attacking = false
				# Chama aniamação de dano e bloqueia o ataque
			pass
		
func verify_shield(value: int) -> void:
	if shielding:
		if (base_defense + bonus_defense) >= value:
			return # Sai sa função verify_shield
		#print(" acabou a defesa")
		var damage = abs ((base_defense + bonus_defense) - value)
		current_health -= damage
		
	else:
		current_health -= value
	
	
func update_mana(type: String, value: int) -> void:
	match type:
		"Increase":
			current_mana += value
			if current_mana >= max_mana:
				current_mana = max_mana
			pass
		"Decrease":
			current_mana -= value
			
			
# Função para teste de dano e morte
# Sempre que apertar "espaço" irá causar 5 de dano
func _process(delta):
	if Input.is_action_just_pressed("ui_select"):
		update_health("Decrease", 5)
	pass

			
