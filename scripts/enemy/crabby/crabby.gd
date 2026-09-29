extends EnemyTemplate

class_name Crabby


func _ready():
	randomize()
	drop_list = {
		"Heal Potion": [
			"res://assets/item/consumable/health_potion.png",
			14,
			"Health",
			5,
			2
			],
		"Mana Potion" :[
			"res://assets/item/consumable/mana_potion.png",
			12,
			"Mana",
			5,
			5
			],
		"Crabby Eye": [
			"res://assets/item/resource/crabby/crab_eye.png",
			1,
			"Resource",
			{},
			3
			],
		"Crabby Pincers": [
			"res://assets/item/resource/crabby/crab_pincers.png",
			1,
			"Resource",
			{},
			7
			],
		"Crabby Belt": [
			"res://assets/item/equipment/crabby_belt.png",
			25,
			"Equipment",
			{
				"Health": 3,
				"Attack": 1
			},
			30
			],
		"Crabby Axe": [
			"res://assets/item/equipment/crabby_axe.png",
			22,
			"Weapon",
			{
				"Attack": 3,
				"Defense": 1
			},
			40
			]
		}
	pass
