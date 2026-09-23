extends EnemyTexture

class_name PinkStarTexture

# Passando o efeito de ataque

func animate(velocity: Vector2) -> void:
	# Essas variáveis can_hit e can_diejá estão no EnemyTemplate
	# inclusive o acesso ao raiz enemy que é o KinemmaticBody2d EnemyTemplate
	if enemy.can_attack or enemy.can_hit or enemy.can_die:
		action_behaviour() 
	else:
		move_behaviour(velocity)
	
func action_behaviour() -> void:
	if enemy.can_die:
		animation.play("dead")
		enemy.can_hit = false
		enemy.can_attack = false

	elif enemy.can_hit:
		animation.play("hit")
		enemy.can_attack = false

	elif enemy.can_attack:
		animation.play("attack_antecipation")
		enemy.set_physics_process(false)
		
	
	
func move_behaviour(velocity: Vector2) -> void:
	if velocity.x != 0:
		# Chama o padrão da cena herdada -> EnemyTexture e executa a animação run correr
		animation.play("run")
	else:
		# Chama o animation padrão da cena herdada -> EnemyTexture e executa a animação idle
		animation.play("idle")

func on_animation_finished(anim_name: String) -> void:
	match anim_name:
		"attack_left":
			enemy.can_attack = false
			enemy.set_physics_process(true)

		"attack_right":
			enemy.can_attack = false
			enemy.set_physics_process(true)

		"hit":
			#print("Entrou no final da animação hit ")
			enemy.can_hit = false
			enemy.can_attack = false
			enemy.set_physics_process(true)
		"dead":
			#print("Entrou no final da animação dead ")
			enemy.kill_enemy() # A ser implementado
			enemy.can_attack = false
		"kill":
			enemy.queue_free()
		"attack_antecipation":
			animation.play("attack" + enemy.attack_animation_sufix)
		
	

