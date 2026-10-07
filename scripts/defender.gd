extends Node2D

@export var arrow: PackedScene

@onready var arrow_spawn: Marker2D = $ArrowSpawn



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$AnimatedSprite2D.flip_h = true	
	
	
var tracking: Array[Area2D] = []
var closest_enemy: Area2D = null
var closest_distance = INF

#detects & adds detected enemy into array
func _on_detection_area_entered(area: Area2D) -> void:
	tracking.append(area)
	
	
#when enemy exits, erase from array
func _on_detection_area_exited(area: Area2D) -> void:
	tracking.erase(area)


#creates arrow and points to direction of enemy position
func _on_timer_timeout() -> void:
	if closest_enemy: 
		var created_arrow = arrow.instantiate()
		add_child(created_arrow)
		
		created_arrow.global_position = arrow_spawn.global_position
		created_arrow.target = closest_enemy


#To track which enemy is closest and target that enemy
func _physics_process(_delta: float) -> void:
	closest_distance = INF
	closest_enemy = null
	if tracking:
		for enemies in tracking:
			var distance = global_position.distance_to(enemies.global_position)
			
			if distance < closest_distance:
				closest_distance = distance
				closest_enemy = enemies
