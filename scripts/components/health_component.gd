class_name HealthComponent 
extends Node

#signal health_changed(current:int, maximum:int)
#signal damaged(amount:int)
signal died

var max_health: int = 10
var current_health: int = 10
var is_dead:bool = false 

func setup(max_hp:int) -> void:
	# on initialization 
	max_health = max_hp 
	current_health = max_hp
	is_dead = false
	#health_changed.emit(current_health,max_health)
	
func take_damage(amount:int) -> void:
	if is_dead or amount <= 0:
		return
	current_health = max(current_health - amount, 0)
	#damaged.emit(amount)
	#health_changed.emit(current_health, max_health)
	if current_health == 0:
		is_dead = true
		died.emit()
