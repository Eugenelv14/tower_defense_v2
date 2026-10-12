extends Node2D

@onready var tower: StaticBody2D = $tower
@onready var upgrade_screen: Control = $CanvasLayer/UpgradeScreen
@onready var spawner: Spawner = $Spawner

signal update_coin_counter(coins:int)
signal update_round_counter(round:int)
signal update_health_bar(current_health: int, max_health: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tower.health.health_changed.connect(update_health_bar.emit)

# LABELS
func _on_spawner_enemy_removed(coins: int) -> void:
	update_coin_counter.emit(coins)

func _on_spawner_wave_started(wave_number: int, _total_waves: int) -> void:
	update_round_counter.emit(wave_number)

# UPGRADE SCREEN
func _on_spawner_waiting_for_player(_next_wave_number: int) -> void:
	upgrade_screen.open()

func _on_upgrade_screen_next_wave_pressed() -> void:
	spawner.continue_to_next_wave()
