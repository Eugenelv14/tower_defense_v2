extends Node2D

const MIN_WAIT_TIME := 0.3

@export var arrow: PackedScene
@onready var arrow_spawn: Marker2D = $ArrowSpawn
@onready var timer: Timer = $Timer

@export var arrow_damage:int = 5
var tracking: Array[Node2D] = []
var closest_enemy: Node2D = null

func _process(_delta: float) -> void:
	$AnimatedSprite2D.flip_h = true

# Find the closest enemy
func _physics_process(_delta: float) -> void:
	# Remove enemies that were freed while in range
	tracking = tracking.filter(is_instance_valid)

	closest_enemy = null
	var closest_distance := INF
	for enemy in tracking:
		var distance := global_position.distance_to(enemy.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_enemy = enemy

# Create an arrow and aim it at the closest enemy
func _on_timer_timeout() -> void:
	if closest_enemy == null:
		return
	var created_arrow = arrow.instantiate()
	created_arrow.target = closest_enemy
	created_arrow.arrow_damage = arrow_damage
	add_child(created_arrow)
	created_arrow.global_position = arrow_spawn.global_position

func upgrade_damage(amount:int) -> void:
	arrow_damage += amount

func upgrade_fire_rate(step:float) -> bool:
	var new_time := snappedf(timer.wait_time - step, 0.01)
	if new_time < MIN_WAIT_TIME - 0.001:
		return false
	timer.wait_time = new_time
	return true

func _on_detection_body_entered(body: Node2D) -> void:
	if body is Enemy and body not in tracking:
		tracking.append(body)

func _on_detection_body_exited(body: Node2D) -> void:
	tracking.erase(body)
