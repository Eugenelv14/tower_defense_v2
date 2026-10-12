extends Control

signal next_wave_pressed
@onready var upgradebutton_1: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/UpgradeCard1/MarginContainer/VBoxContainer/Upgradebutton1
@onready var upgradebutton_2: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/UpgradeCard2/MarginContainer/VBoxContainer/Upgradebutton2
@onready var upgrade_button_3: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/UpgradeCard3/MarginContainer/VBoxContainer/UpgradeButton3

func open() -> void:
	show()

func close() -> void:
	hide()


func _on_start_next_wave_pressed() -> void:
	close()
	next_wave_pressed.emit()


func _on_upgradebutton_1_pressed() -> void:
	pass # Replace with function body.
