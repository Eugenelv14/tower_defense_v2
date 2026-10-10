extends Node2D

@onready var upgrade_screen: Control = $CanvasLayer/UpgradeScreen
@onready var spawner: Spawner = $Enemy_Container/Spawner

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_spawner_waiting_for_player(next_wave_number: int) -> void:
	upgrade_screen.open()


func _on_upgrade_screen_next_wave_pressed() -> void:
	spawner.continue_to_next_wave()
