extends TextureRect

class_name ArmorContainer

onready var armor_item: TextureRect = get_node("Item")

var armor_dictionary: Dictionary ={}
var armor_name: String = ""
var armor_type: String = ""
var armor_texture_path: String = ""

var armor_price: int

var can_click = false

func update_armor_slot(item_texture: StreamTexture, item_info: Array) -> void:
	if armor_name != "":
		get_tree().call_group("inventory",
			"update_slot",
			armor_name,
			armor_item.texture,
			[
				armor_texture_path,
				armor_type,
				armor_dictionary,
				armor_price,
				1
			]
		)
		
		reset()
		
	armor_item.texture = item_texture
	armor_texture_path = item_info[0]
	armor_name = item_info[1]
	armor_type = item_info[2]
	armor_dictionary = item_info[3]
	armor_price = item_info[4]
	# Enviar os atributos ao status em stats
	armor_item.show()
	# Enviar os atributos do equipamento ao sistema de status - stats
	get_tree().call_group("stats_hud", "update_bonus_stats", armor_dictionary, false)
		
func reset() -> void:
	armor_name = ""
	armor_type = ""
	armor_texture_path = ""
	
	armor_price = 0
	armor_item.texture = null
	
	# Resetar os stats/bonus no stats
	armor_dictionary = {}
	pass
	




func on__mouse_entered():
	can_click = true
	modulate.a = 0.5
	pass # Replace with function body.


func on_mouse_exited():
	can_click = false
	modulate.a = 1.0
	pass # Replace with function body.
