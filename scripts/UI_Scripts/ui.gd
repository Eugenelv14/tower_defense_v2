extends Control

@export var main_control: Node2D
@onready var coin_counter: Label = $coin_counter
@onready var round_counter: Label = $round_counter
@onready var tower_health_bar: ProgressBar = $Tower_label/tower_health_bar

var current_coins: int = 0
var current_round: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coin_counter.text = "Coins: " + str(current_coins)
	round_counter.text = "Round: " + str(current_round)
	
	#Connects main node to labels
	main_control.update_coin_counter.connect(update_coin_counter)
	main_control.update_round_counter.connect(update_round_counter)

	#Connects main node to health 
	main_control.update_health_bar.connect(_on_health_changed)
	
func update_coin_counter(coins:int) -> void:
	current_coins += coins
	coin_counter.text = "Coins: " + str(current_coins)

func update_round_counter(current_wave:int) -> void:
	current_round = current_wave
	round_counter.text = "Round: " + str(current_round)

func _on_health_changed(current: int, maximum: int) -> void:
	tower_health_bar.max_value = maximum
	tower_health_bar.value = current
