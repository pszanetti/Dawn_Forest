extends CanvasLayer

# Guarda Referência oa inventário
onready var inventory_container: Control = get_node("InventoryContainer")

var can_show_container: bool = true

# Guarda referencia ao sistema de Status -> StatsContainer
onready var stats_container: Control = get_node("StatsContainer")
# Guarda referência ao EquipamentContainer
onready var equipment_container = get_node("EquipamentContainer")

func _process(_delta) -> void:
	if can_show_container:
		show_inventory()
		show_stats()


func show_inventory() -> void:
#	print("Entrou no Show")
	if Input.is_action_just_pressed("inventory"):
#		equipment_container.visible = false
		hide_equipment_container()	# -> Some com o EquipmentContainer
		# vai inverter o bool ! = not
		inventory_container.is_visible = ! inventory_container.is_visible
		
		if inventory_container.is_visible:
			inventory_container.animation.play("show_container")
		else:
			inventory_container.reset()
			inventory_container.animation.play("hide_container")
			equipment_container.animtaion.play("show_container")
			
		
		if stats_container.is_visible:
			stats_container.reset() # A ser inserido
			stats_container.is_visible = false
			stats_container.animation.play("hide_container")
			pass


func show_stats() -> void:
	if Input.is_action_just_pressed("stats"):
		equipment_container.visible = false
		hide_equipment_container()	# -> Some com o EquipmentContainer
		
		stats_container.is_visible = ! stats_container.is_visible
		if stats_container.is_visible:
			stats_container.animation.play("show_container")
		else:
			stats_container.reset() # A ser inserido
			stats_container.animation.play("hide_container")
			equipment_container.animtaion.play("show_container")
			
		if inventory_container.is_visible:
			inventory_container.reset()
			inventory_container.is_visible = false
			inventory_container.animation.play("hide_container")
			
			
func hide_equipment_container() -> void:
	equipment_container.animtaion.play("hide_container")
	
