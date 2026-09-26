extends CanvasLayer

onready var inventory: Control = get_node("InventoryContainer")

func _process(_delta) -> void:
	show_inventory()
	


func show_inventory() -> void:
#	print("Entrou no Show")
	if Input.is_action_just_pressed("inventory"):
		if inventory.visible:
			print("inventário")
			inventory.animation.play("hide_container")
		else:
			inventory.animation.play("show_container")
		return

