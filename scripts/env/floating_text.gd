extends Label

class_name FloatText

onready var tween: Tween = get_node("Tween")

var value: int
var mass: int = 20

var velocity: Vector2
var gravity: Vector2 = Vector2.UP

var type: String = ""
var type_sign: String = ""

export(Color) var exp_color
export(Color) var heal_color
export(Color) var mana_color
export(Color) var damage_color

func _ready():
	randomize()
	velocity = Vector2(
		rand_range(-10, 10),
		-30
		)
	floating_text()


func floating_text() -> void:
	text = type_sign + str(value)
	match type:
		"Exp":
			modulate = exp_color
		"Heal":
			modulate = heal_color
		"Mana":
			modulate = mana_color
		"Damage":
			modulate = damage_color
			
	
func interpolate() -> void:
	# Para tirar as "WARNINGS", basta incluir uma variável que tenha "_" no começo
	# como var _interpolate_modulate: bool = &
	# var _start: bool = tween.start()
	var _interpolate_modulate: bool = tween.interpolate_property(
		self,
		"modulate:a",		# -> Mexe na cor - modulação de alpha (transparência)
		1.0,
		0.0,
		0.3,
		Tween.TRANS_LINEAR,
		Tween.EASY_OUT,
		0.7								# FINAL -> Começa em 0.7
		)
	var _interpolate_scale_up: bool = tween.interpolate_property(			# INICIO -> começa em ZERO
		self,
		"rect_scale",		# -> Mexe na escala - Tamanho do Texto
		Vector2(0.0, 0.0),
		Vector2(1.0, 1.0),
		0.3,
		Tween.TRANS_LINEAR,
		Tween.EASY_OUT
		)
	var _interpolate_scale_down: bool = tween.interpolate_property(
		self,
		"rect_scale",		# -> Mexe na escala - Tamanho do Texto
		Vector2(1.0, 1.0),
		Vector2(0.4, 0.4),
		1.0,
		Tween.TRANS_LINEAR,
		Tween.EASY_OUT,
		0.6					# - Mexe no meio
		)
	var _start: bool = tween.start()	# -> Executa a interpolação
	yield(tween, "tween_all_completed")    # -> Aguarda a execução de todas as interpolações
	queue_free()
	
func _process(delta) -> void:
	velocity += gravity * mass * delta
	rect_position += velocity * delta 	# -> rect e position pois position está dentro do rect
	pass
