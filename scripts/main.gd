extends Node2D

@onready var round_counter: Label = $round_counter
@onready var coin_counter: Label = $coin_counter
@export var spawner: Spawner
@export var enemy: PackedScene


var current_coins: int = 0
var current_round: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coin_counter.text = "Coins: " + str(current_coins)
	round_counter.text = "Round: " + str(current_round)
	spawner.wave_started.connect(_round_change)
	
func _coin_earned(_enemy: Enemy) -> void:
	current_coins += 1
	coin_counter.text = "Coins: " + str(current_coins)

func _round_change(_wave_number: int, _total_waves: int) -> void:
	current_round = _wave_number
	round_counter.text = "Round: " + str(current_round)
