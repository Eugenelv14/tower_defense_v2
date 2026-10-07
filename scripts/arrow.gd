extends Area2D

var target: Area2D

var arrow_speed = 300.0



func _process(delta: float) -> void:
	if target:
		var direction_to_enemy = global_position.direction_to(target.global_position)
		rotation = direction_to_enemy.angle()
		global_position += direction_to_enemy * arrow_speed * delta


func _on_area_entered(area: Area2D) -> void:
	if target == area:
		queue_free()
