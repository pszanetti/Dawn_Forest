extends Sprite

class_name PlayerTexture

# Aqui eu pego o path e altero a variável animation para guardar o 
# Node cujo caminho estava descrito animation e guardo como Node tipo AnimationPlayer

# Guarda o acesso ao node Animation na variável animation que fica sendo o AnimationPlayer
export(NodePath) onready var animation = get_node(animation) as AnimationPlayer

# Guarda o acesso ao node Player na variável player para acessar suas variáveis e funções
export(NodePath) onready var player = get_node(player) as KinematicBody2D

# Recebe o valor de velocity que está no script do Node raiz (Player) e armazena
# na variável direction
func animate(direction: Vector2) -> void:
# print(direction) checar se está recebendo o velocity

	verify_direction(direction)
	
	if direction.y != 0:
		vertical_behaviour(direction)
	elif player.landing:
		animation.play("landing")
		player.set_physics_process(false)
	else:
		horizontal_behaviour(direction)

func verify_direction(direction: Vector2) -> void:
	if direction.x > 0:
		flip_h = false
	elif direction.x < 0:
		flip_h = true

func vertical_behaviour(direction: Vector2) -> void:
	# Se direção de y > 0 está caindo, animação fall
	if direction.y > 0:
		player.landing = true
		animation.play("fall")
	# Se direção de y < 0 está pulando, animação jump
	elif direction.y < 0:
		animation.play("jump")

 
func horizontal_behaviour(direction: Vector2) -> void:
	if direction.x != 0:
		animation.play("run")
	else:
		animation.play("idle")
	


func _on_animation_finished(anim_name: String) -> void:
	match anim_name:
		"landing":
			player.landing = false
			player.set_physics_process(true)

