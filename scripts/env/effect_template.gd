extends AnimatedSprite

# Gravado na pasta /scripts/env
class_name EffectTemplate

func play_effect() -> void:
	play()
	pass


func on_animation_finished():
	queue_free()
	pass # Replace with function body.
