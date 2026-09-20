extends KinematicBody2D

class_name EnemyTemplate

onready var texture: Sprite = get_node("Texture")
onready var floor_ray: RayCast2D = get_node("FloorRay")
onready var animation: AnimationPlayer = get_node("Animation")


var can_die: bool = false
var can_hit: bool = false
var can_attack: bool = false


var velocity: Vector2
var player_ref: Player = null

# Preparando a lista para itens que serão dropados
var drop_list: Dictionary
# Multiplicador de Drop dos Itens
var drop_bonus: int = 1

export(int) var speed 
export(int) var gravity_speed
export(int) var proximity_threshold
export(int) var raycast_default_position

func _physics_process(delta: float) -> void:
	gravity(delta)
	move_behaviour()
	verify_position()
	texture.animate(velocity)
	velocity = move_and_slide(velocity, Vector2.UP)
		
	

func gravity(delta: float) -> void:
	velocity.y = gravity_speed * delta
	
	
func move_behaviour() -> void:
	if player_ref != null:
		var distance: Vector2 = player_ref.global_position - global_position
		var direction = distance.normalized() # retorna número inteiro de 0 a 1
		if abs(distance.x) <= proximity_threshold:
			velocity.x = 0
			can_attack = true
		elif floor_collision() and not can_attack:
			velocity.x = direction.x * speed
		else:
			velocity.x = 0
		return # Sai da função move_behaviour
	velocity.x = 0

func floor_collision() -> bool:
	if floor_ray.is_colliding():
		return true
	# Sai da função floor_collision retornando verdadeiro
	return false
	# Retorna falso e sai da função floor_collision

func verify_position() -> void:
	if player_ref != null:
		# Pega o sinal positivo ou negativo sendo o resultado 1 e -1
		var direction: float = sign(player_ref.global_position.x - global_position.x)
		if direction > 0:
			texture.flip_h = true
			floor_ray.position.x = abs(raycast_default_position)
		elif direction < 0:
			texture.flip_h = false
			floor_ray.position.x = raycast_default_position
		
func kill_enemy() -> void:
	animation.play("kill")
	spawn_item_probability()
	
	
# Método para dropar os itens

func spawn_item_probability() -> void:
	var random_number: int = randi() % 21
	if random_number < 6:
		drop_bonus = 1
	elif random_number > 6 and drop_bonus < 14:
		drop_bonus = 2
	else:
		drop_bonus = 3
		
	print ("Multiplicador de Drop" + str(drop_bonus))
	
	for key in drop_list.keys():
		# Sorteando os itens
		var rng:int = randi() % 100 + 1    # -> o "+1" é para o número sair entre 1 e 100 
		
		if rng <= drop_list[key][1] * drop_bonus:
			# Armazena a imagem png do item que está no indíce 0 da chave
			var item_texture: StreamTexture = load(drop_list[key][0])     
			# Guarda demais informações do item
			var item_info: Array = [
				drop_list[key][0],
				drop_list[key][2],
				drop_list[key][3],
				drop_list[key][4],
				1                 # -> Quantidade do array
				]
			spawn_physic_item(key, item_texture, item_info)
		
func spawn_physic_item(key: String, item_texture: StreamTexture, item_info: Array) -> void:
	
	pass
