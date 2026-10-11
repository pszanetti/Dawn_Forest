extends Control

signal finished

onready var label_name: Label = get_node("Background/Name")
onready var portrait: TextureRect = get_node("Background/Portrait")
onready var text_label: RichTextLabel = get_node("Background/TextLabel")

onready var animation: AnimationPlayer = get_node("Animation")

onready var timer: Timer = get_node("Timer")


var dialog_size: int
var dialog_index: int = 0

var dialog_list: Dictionary = {}

export(float) var wait_time = 0.02

func _ready() -> void:
	dialog_size = dialog_list["dialog"].size
	
	if dialog_list["portrait"] != null:
		label_name.text = dialog_list["name"]
		text_label.rect_position = Vector2(47, 24)
		portrait.texture = load(dialog_list[portrait])
		
	show_dialog()
	
func show_dialog() -> void:
	
	pass
		pass
	pass


