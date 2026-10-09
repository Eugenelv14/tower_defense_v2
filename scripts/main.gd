extends Node2D

@onready var round_counter: Label = $round_counter
@onready var coin_counter: Label = $coin_counter

var current_coins: int = 0
var current_round: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coin_counter.text = "Coins: " + str(current_coins)
	round_counter.text = "Round: " + str(current_round)
	
