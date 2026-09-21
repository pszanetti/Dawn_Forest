extends KinematicBody2D

class_name Player

# Carrega o Node Texture !!!
onready var player_sprite: Sprite = get_node("Texture")

# Variáveis para o caso de personagem estiver na parede
onready var wall_ray: RayCast2D = get_node("WallRay")
# Acessa o node Stats e seus atributos:
onready var stats: Node = get_node("Stats")


export(int) var wall_jump_speed
export(int) var wall_gravity
export(int) var wall_impulse_speed
var not_on_all: bool = true
var on_wall: bool = false
var direction: int = 1

var velocity: Vector2
var jump_count: int = 0
var landing: bool =  false

# Variáveis responsáveis por ataque, defesa e agachar 
# E que bloqueiam as funções de pulo e movimento lateral
var attacking: bool = false
var defending: bool = false
var crouching: bool = false
# Variável que desbloqueia outras funções
var can_track_input: bool = true

# Variáveis para dano 
var dead: bool = false
var on_hit: bool = false

# Variável para orientar a direção do efeito jump
# Esse valor é alterado no script texture
var flipped: bool = false

export(int) var speed

export(int) var jump_speed
export(int) var player_gravity

func _physics_process(delta):
	horizontal_movement_env()
	vertical_movement_env()
	
# Função responsável pelo ataque, agachar e defender
	actions_env()
	
# Função responsável por aplicar a gravidade
	gravity(delta)
	
	# IMPORTANTE: se não colocar Vector.UP is_on_floor serṕá sempre falso
	velocity = move_and_slide(velocity, Vector2.UP)
	player_sprite.animate(velocity)
	
func horizontal_movement_env() -> void:
	var input_direction: float = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if can_track_input == false or attacking:
		velocity.x =0
		return    # -> o return serve para não rodar o código que está abaixo, saindo assim da função
	velocity.x = input_direction * speed
	# IMPORTANTE -> animate será um metódo criado no script em Texture !!!
	player_sprite.animate(velocity)   #IMPORTANTE ESSA LINHA SUMIU !?

func vertical_movement_env() -> void:
	if is_on_floor() or is_on_wall():
		jump_count = 0
	# para simplificar a comparação evitando linhas de código grandes
	var jump_condition: bool = can_track_input and not attacking
	# just_pressed, indica uma vez ó mesmo que a tecla espeço continue apertada
	if Input.is_action_just_pressed("ui_select") and jump_count < 2 and jump_condition:
		jump_count += 1
		spawn_effect("res://scenes/effect/dust/jump.tscn", Vector2(0, 18), flipped)
		if next_to_wall() and not is_on_floor():
			velocity.y = wall_jump_speed
			velocity.x += wall_impulse_speed * direction
		else:
			velocity.y = jump_speed

func next_to_wall() -> bool:
	if wall_ray.is_colliding() and not is_on_floor():
		if not_on_all:
			velocity.y = 0
			not_on_all = false
		return true
	
	else:
		not_on_all = true
		return false
	


# Função responsável pelo ataque, agachar e defender
func actions_env() -> void:
	attack()
	crouch()
	defense()
		
func attack() -> void:
	var attack_condition: bool = not attacking and not crouching and not defending
	if Input.is_action_just_pressed("Attack") and attack_condition and is_on_floor():
		attacking = true
		player_sprite.normal_attack = true
		pass	
		
		
func crouch() -> void:
	if Input.is_action_pressed("Crouch") and is_on_floor() and not defending:
		crouching = true
		can_track_input = false
		stats.shielding = false
	elif not defending:
		crouching = false
		can_track_input = true
		player_sprite.crouch_off = true
		stats.shielding = false
	
	
func defense() -> void:
	if Input.is_action_pressed("Defense") and is_on_floor() and not crouching:
		defending = true
		can_track_input = false
		stats.shielding = true
	elif not crouching:
		defending = false
		can_track_input = true
		player_sprite.shield_off = true
		stats.shielding = false	# Não está na defesa
	
# Aplica a Gravidade
func gravity(delta) -> void:
	if next_to_wall():
		velocity.y += wall_gravity * delta
		if velocity.y >= wall_gravity:
			velocity.y = wall_gravity
			
	else:
		velocity.y += player_gravity * delta
		if velocity.y >= player_gravity:
			velocity.y = player_gravity
		
func spawn_effect(effect_path: String, offset: Vector2, is_flipped: bool) -> void:
	# OffSet é para saber se é para direita ou esquerda que  é definido em is_flipped
	#var effect_instance: EffectTemplate = load(effect_path).instance()
	var effect_instance: EffectTemplate = load(effect_path).instance()
	get_tree().root.call_deferred("add_child", effect_instance)
	if is_flipped:
		effect_instance.flip_h = true
		
	effect_instance.global_position = global_position + offset
	effect_instance.play_effetc()
	
