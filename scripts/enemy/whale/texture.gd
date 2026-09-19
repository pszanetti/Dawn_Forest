# extends Sprite
extends EnemyTexture
# Para Herdarmos do script EnemyTexute todas as suas propriedade e funções

class_name WhaleTexture

func animate(velocity: Vector2) -> void:
	move_behaviour(velocity)
	pass
	
func move_behaviour(velocity: Vector2) -> void:
	if velocity.x != 0:
		# Chama o padrão da cena herdada -> EnemyTexture e executa a animação run correr
		animation.play("run")
	else:
		# Chama o animation padrão da cena herdada -> EnemyTexture e executa a animação idle
		animation.play("idle")
	pass
