extends Node2D

@export var arrow: PackedScene
@onready var arrow_spawn: Marker2D = $ArrowSpawn

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
	add_child(created_arrow)
	created_arrow.global_position = arrow_spawn.global_position

func _on_detection_body_entered(body: Node2D) -> void:
	if body is Enemy and body not in tracking:
		tracking.append(body)

func _on_detection_body_exited(body: Node2D) -> void:
	tracking.erase(body)
