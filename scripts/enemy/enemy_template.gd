extends KinematicBody2D

class_name EnemyTemplate

onready var texture: Sprite = get_node("Texture")
onready var floor_ray: RayCast2D = get_node("FloorRay")
onready var animation: AnimationPlayer = get_node("Animation")


var can_die: bool = false
var can_hit: bool = false
var can_attack: bool = false


var velocity: Vector2
var player_ref: Player = null

export(int) var speed 
export(int) var gravity_speed
export(int) var proximity_threshold

func _physics_process(delta: float) -> void:
	gravity(delta)
	move_behaviour()
	
	

func gravity(delta: float) -> void:
	velocity.y = gravity_speed * delta
	
	
func move_behaviour() -> void:
	if player_ref != null:
		var distance: Vector2 = player_ref.global_position - global_position
		var direction = distance.normalized() # retorna número inteiro de 0 a 1
		if abs(distance.x) <= proximity_threshold:
			velocity.x = 0
			can_attack = true
		elif floor_collision() and not can_attack:
			velocity.x = direction.x * speed
		else:
			velocity.x = 0
		return # Sai da função move_behaviour
	velocity.x = 0

func floor_collision() -> bool:
	if floor_ray.is_colliding():
		return true
	# Sai da função floor_collision retornando verdadeiro
	return false
	# Retorna falso e sai da função floor_collision

