extends Control

signal upgrade_purchased(cost: int, name: String, amount: int)
signal next_wave_pressed

func open() -> void:
	show()

func close() -> void:
	hide()


func _on_start_next_wave_pressed() -> void:
	close()
	next_wave_pressed.emit()


func _on_upgradebutton_1_pressed() -> void:
	var upgrade_type := "damage_upgrade"
	var upgrade_cost := 5
	var upgrade_amount := 3
	upgrade_purchased.emit(upgrade_cost,upgrade_type,upgrade_amount)


func _on_upgradebutton_2_pressed() -> void:
	var upgrade_type := "health_upgrade"
	var upgrade_cost := 8
	var upgrade_amount := 5
	upgrade_purchased.emit(upgrade_cost,upgrade_type,upgrade_amount)
	
func _on_upgrade_button_3_pressed() -> void:
	var upgrade_type := "speed_upgrade"
	var upgrade_cost := 3
	var upgrade_amount := 1
	upgrade_purchased.emit(upgrade_cost,upgrade_type,upgrade_amount)
