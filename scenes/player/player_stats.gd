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

func _ready() -> void:
	current_health = base_health + bonus_health
	max_health = current_health
	
	current_mana = base_mana + bonus_mana
	max_mana = current_mana
	
	pass
