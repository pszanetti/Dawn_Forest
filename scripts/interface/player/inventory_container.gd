extends Control

class_name InventoryContainer

onready var slot_container: GridContainer = get_node("VContainer/BackGround/GridContainer")

var current_state: String

var can_click: bool = false
var is_visible: bool = false

var item_index: int
# Listas
var slot_item_info: Array = [
	"", "", "", "", "", "", "", "", "",
	"", "", "", "", "", "", "", "", "",
	"", "", "", "", "", "", "", "", ""
	]

var slot_list: Array = [
	"", "", "", "", "", "", "", "", "",
	"", "", "", "", "", "", "", "", "",
	"", "", "", "", "", "", "", "", ""
	]
	
func _ready() -> void:
	for children in slot_container.get_children():
		children.connect("empty_slot", self, "empty_slot")
		
func update_slot(item_name: String, item_image: StreamTexture, item_info: Array) -> void:
	# Verifica se o item já existe
	var existing_item_index: int = slot_list.find(item_name)
	if existing_item_index != -1:  # Encontrou o item !?
		var item_slot: TextureRect = slot_container.get_child(existing_item_index)
		if item_slot.amount < 9 and item_slot.item_type != "Equipament" and item_slot.item_type != "Weapon":
			var current_amount: int = item_slot.amount + item_info[4]
			if current_amount > 9:
				# Resto -> leftover
				var leftover: int = current_amount - 9
				item_info[3] = 9 - item_slot.amount 
				item_slot.update_item(item_name, item_image, item_info)
				item_info[3] = leftover
				update_slot(item_name, item_image, item_info) 
				return
			item_slot.update_item(item_name, item_image, item_info) # Se não exceder 9
			return
		pass
	
func update_slot() -> void:
	
	pass
	
	
func empty_slot(index: int) -> void:
	slot_list[index] = ""
	slot_item_info[index] = ""
	pass
