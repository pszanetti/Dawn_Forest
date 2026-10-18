extends Control

signal finished

onready var label_name: Label = get_node("Background/Name")
onready var portrait: TextureRect = get_node("Background/Portrait")
onready var text_label: RichTextLabel = get_node("Background/TextLabel")

onready var animation: AnimationPlayer = get_node("Animation")

onready var timer: Timer = get_node("Timer")


var dialog_size: int
var dialog_index: int = 0

# Pular dialogo
var can_skip_dialog: bool = false

var dialog_list: Dictionary = {
	"dialog": [
		"Ola aventureiro, voce deve ter viajado muitas e muitas leguas para estar aqui. Gostaria muito de saber por onde voce esteve e por quais aventuras passou",
		"Em que posso te ajudar ?"
		],
		"portrait": null,
		"name": ""
}

export(float) var wait_time = 0.02

func _ready() -> void:
	animation.play("fade_in")
	yield(animation, "animation_finished")
	dialog_size = dialog_list["dialog"].size()
	
	if dialog_list["portrait"] != null:
		label_name.text = dialog_list["name"]
		text_label.rect_position = Vector2(60, 24)
		portrait.texture = load(dialog_list["portrait"])
		
	show_dialog()
	
# Fazendo trocar a frase na caixa de diálogo
func _process(_delta) -> void:
	if Input.is_action_just_pressed("interact") and can_skip_dialog:
		can_skip_dialog = false
		show_dialog()
	
	
func show_dialog() -> void:
	# Caso as frases terminem ele fecha o DialogContainer
	if dialog_index == dialog_size:
		animation.play("fade_out")
		yield(animation, "animation_finished")
		emit_signal("finished")
		queue_free()
		return
	# Reseta o diálogo atual
	text_label.percent_visible = 0
	text_label.text = dialog_list["dialog"][dialog_index]
	# Passa ṕpara a próxima frase
	dialog_index += 1
	# Enquanto a text_label for menor que o tamanho da dialog_list
	while text_label.visible_characters < len(text_label.text):
		# Acresce a quantidade de caracteres viviveis por 1
		text_label.visible_characters += 1
		timer.start(wait_time)
		yield(timer, "timeout")
		
	# Quando chegar no final da frase poderá mudar para a próxima frase
	can_skip_dialog = true



