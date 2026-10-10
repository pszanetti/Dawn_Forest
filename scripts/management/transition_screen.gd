extends CanvasLayer

onready var animation: AnimationPlayer = get_node("Animation")

# Variável para identificar a scene que vai ser carregada na transição
var scene_path: String = ""

func fade_in () -> void:
	animation.play("fade_in")
	

	
	pass # Replace with function body.


func on_animation_finished(anim_name: String) -> void:
	if anim_name == "fade_in":
		var _change_scene: bool = get_tree().change_scene(scene_path)
		animation.play("fade_out")
	
