extends Sprite

class_name PlayerTexture

# Aqui eu pego o path e altero a variável animation para guardar o 
# Node cujo caminho estava descrito animation e guardo como Node tipo AnimationPlayer

export(NodePath) onready var animation = get_node(animation) as AnimationPlayer


# Revebe o valor de velocity que está no script do Node raiz (Player) e armazena
# na variável direction
func animate(direction: Vector2) -> void:
# print(direction) checar se está recebendo o velocity
	verify_direction(direction)
	horizontal_behaviour(direction)

func verify_direction(direction: Vector2) -> void:
	if direction.x > 0:
		flip_h = false
	elif direction.x < 0:
		flip_h = true
	pass
 
func horizontal_behaviour(direction: Vector2) -> void:
	if direction.x != 0:
		animation.play("run")
	else:
		animation.play("idle")
	
