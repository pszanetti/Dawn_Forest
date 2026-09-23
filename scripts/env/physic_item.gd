extends RigidBody2D

class_name PhysicItem

onready var sprite: Sprite = get_node("Texture")

# Criando a referência ao Player
var player_ref: KinematicBody2D = null

# Capturando os dados do item
var item_name: String
var item_info_list: Array
var item_texture: StreamTexture

# Contante para carregar o efeito de enviar ao inventário -> pegar o item dropado
const COLLECT_EFFECT: PackedScene = preload("res://scenes/effect/general_effect/collect_item.tscn")
# IMPORTANTE -> preload carrega antes de executar o jogo
# é semelhante a onready var

func _ready() -> void:
	randomize()
	aplly_random_impulse()
	
	

func aplly_random_impulse() -> void:
	# Aplica a força e direção do lançamento do Item
	apply_impulse(
		Vector2.ZERO,
		Vector2( 
			rand_range(-60, 60), # -> Angulo do impulso
			-90                  # -> Altura
			)
	)
	
func update_item_info(key: String, texture: StreamTexture, item_info: Array) -> void:
	yield(self, "ready")        # Aguarda (yield) o objeto PhysicItem (self) estiver pronto
	
	item_name = key
	item_texture = texture
	item_info_list = item_info
	# Colocando a imagem png no item dropado
	sprite.texture = texture

 

func on_screen_exited():
	queue_free()
	pass # Replace with function body.



func on_body_entered(body: Player):
	player_ref = body
	

func on_body_exited(_body):   # -> Coloca underscore "_" para dizer que não vamos utilizar esse argumento
	player_ref = null

func _process(_delta) -> void:
	if player_ref != null and Input.is_action_just_released("interact"):
		# Emitir sinal para enviar o item ao inventário
		spawn_effect()
		queue_free()
		pass

func spawn_effect() -> void:
	var collect_effect: EffectTemplate = COLLECT_EFFECT.instance()
	get_tree().root.call_deferred("add_child", collect_effect)
	collect_effect.global_position = global_position
	collect_effect.play_effect()
	
