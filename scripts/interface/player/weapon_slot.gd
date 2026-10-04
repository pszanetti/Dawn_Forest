extends TextureRect


class_name WeaponContainer

var can_click: bool = false

onready var weapon_item: TextureRect = get_node("Item")


var weapon_dictionary: Dictionary = {}

var weapon_name: String = ""
var weapon_type: String = ""
var weapon_texture_path: String = ""

var weapon_price: int

func update_weapon_slot(item_texture: StreamTexture, item_info:Array) -> void:
	print("Equipando arma")
	if weapon_name != "":
		get_tree().call_group("inventory",
			"update_slot",
			weapon_name,
			weapon_item.texture,
				[
				weapon_texture_path,
				weapon_type,
				weapon_dictionary,
				weapon_price,
				1
				]
			)
		reset()
	weapon_item.texture = item_texture
	weapon_texture_path = item_info[0]
	weapon_name = item_info[1]
	weapon_type = item_info[2]
	weapon_dictionary = item_info[3]
	weapon_price = item_info[4]
	
	weapon_item.show()
	
	# Enviar os atributos do equipamento ao sistema de status - stats
	get_tree().call_group("stats_hud", "update_bonus_stats", weapon_dictionary, false)
	
func reset() -> void:
	weapon_name = ""
	weapon_type = ""
	weapon_texture_path = ""
	
	weapon_price = 0
	weapon_item.texture = null
	# Resetar os stats bonus da arma equipada anteriormente
	weapon_dictionary = {}
	
	pass



func on_mouse_entered():
	can_click = true
	modulate.a = 0.5
	pass # Replace with function body.


func on_mouse_exited():
	can_click = false
	modulate.a = 1.0
	pass # Replace with function body.
