# extends Sprite
extends EnemyTexture
# Para Herdarmos do script EnemyTexture todas as suas propriedade e funções

class_name CrabbyTexture

# Passando o efeito de ataque
const ATTACK_EFECT: PackedScene = preload("res://scenes/effect/general_effect/crabby_attack_effect.tscn")
var can_sapwn_effect: bool = true

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
		attack_area_collision.set_deferred("disable", true)
	elif enemy.can_hit:
		#print("Entrou")
		animation.play("hit")
		enemy.can_attack = false
		attack_area_collision.set_deferred("disable", true)
	elif enemy.can_attack:
		if can_sapwn_effect:
			spawn_attack_efect()
			can_sapwn_effect = false
		animation.play("attack" + enemy.attack_animation_sufix)
		
	pass
	
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
			can_sapwn_effect = true
		"attack_right":
			enemy.can_attack = false
			enemy.set_physics_process(true)
			can_sapwn_effect = true
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
		
func spawn_attack_efect() -> void:
	var effect = ATTACK_EFECT.instance()
	get_tree().root.call_deferred("add_child", effect)
	effect.global_position = global_position
	effect.play_effect()
	
