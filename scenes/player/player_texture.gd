extends Sprite

class_name PlayerTexture

# Ataque normal é o ataque com espada
var normal_attack: bool = false

# Define o lado em que está atacando,a animação attack_right
var suffix: String = "_right"

#Verifica se o shield (defesa) e o crouch (agachar) estão desabilitados
var shield_off: bool = false
var crouch_off: bool = false
# Aqui eu pego o path e altero a variável animation para guardar o 
# Node cujo caminho estava descrito animation e guardo como Node tipo AnimationPlayer

# Guarda o acesso ao node Animation na variável animation que fica sendo o AnimationPlayer
export(NodePath) onready var animation = get_node(animation) as AnimationPlayer

# Guarda o acesso ao node Player na variável player para acessar suas variáveis e funções
export(NodePath) onready var player = get_node(player) as KinematicBody2D

# Guarda informções sobre o CollisiobShape dentro do Node AttackArea
export(NodePath) onready var attack_collision = get_node(attack_collision) as CollisionShape2D

# Recebe o valor de velocity que está no script do Node raiz (Player) e armazena
# na variável direction
func animate(direction: Vector2) -> void:
# print(direction) checar se está recebendo o velocity
	verify_direction(direction)
	if player.on_hit or player.dead:
		hit_behaviour()
		pass
	# next_to_wall() função no script do node Player
	elif player.attacking or player.defending or player.crouching or player.next_to_wall():
		action_behaviour()
	elif direction.y != 0:
		vertical_behaviour(direction)
	elif player.landing:
		animation.play("landing")
		player.set_physics_process(false)
	else:
		horizontal_behaviour(direction)
		
# Verifica se vai atacar ou defender ou agachar (crouch)
func action_behaviour() -> void:
	if player.next_to_wall():
		animation.play("wall_slide")
	elif player.attacking and normal_attack:
		animation.play("attack" + suffix)
	elif player.defending and shield_off:
		animation.play("shield")
		shield_off = false
	elif player.crouching and crouch_off:
		animation.play("crouch")
		crouch_off = false
	pass
	
# Função para verificar se o player está apontando para a direita ou esquerda
func verify_direction(direction: Vector2) -> void:
	if direction.x > 0:
		flip_h = false
		suffix = "_right"
		player.direction = -1
		direction = Vector2.ZERO
		player.wall_ray.cast_to = Vector2( 5.5, 0)
	elif direction.x < 0:
		flip_h = true
		suffix = "_left"
		player.direction = 1
		direction = Vector2(-2, 0)
		player.wall_ray.cast_to = Vector2( -7.5, 0)
		
func hit_behaviour() -> void:
	player.set_physics_process(false)
	# set_deferred serve para acessar imediatamente as propriedades de certos Nodes
	attack_collision.set_deferred("disabled", true)	# Desabilitando a detecção da colisão do ataque
	if player.dead:
		animation.play("dead")
	elif player.on_hit:
		animation.play("hit")
	
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
		"attack_left":
			normal_attack = false
			player.attacking = false 
			pass
		"attack_right":
			normal_attack = false
			player.attacking = false
			
		"hit":
			player.on_hit = false
			player.set_physics_process(true)
			
			if player.defending:
				animation.play("shield")
				
			if player.crouching:
				animation.play("crouch")
			pass

