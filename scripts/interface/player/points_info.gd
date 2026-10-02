extends TextureRect

class_name PointInfo

onready var animation: AnimationPlayer = get_node("Animation")
onready var available_points: Label = get_node("AvailablePoints")

func update_text_value(points: String) -> void:
	available_points.text = points
	pass
	
func play_animation(anim_name: String) -> void:
	animation.play(anim_name)
	


