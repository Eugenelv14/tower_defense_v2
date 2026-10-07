class_name WaveData
extends Resource

@export var groups: Array[SpawnGroup] = []

# Just counts how many enemies there are 
func get_total_count() -> int:
	var total := 0
	for group in groups:
		if group.enemy != null:
			total += group.count
	return total
