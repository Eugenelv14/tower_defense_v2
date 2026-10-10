extends Control

signal next_wave_pressed

func open() -> void:
	show()

func close() -> void:
	hide()


func _on_start_next_wave_pressed() -> void:
	close()
	next_wave_pressed.emit()
