class_name Spawner
extends Node2D

signal wave_started(wave_number: int, total_waves: int)
signal wave_cleared(wave_number: int)
signal waiting_for_player(next_wave_number: int)   # show the upgrade screen on this
signal all_waves_completed
signal enemy_removed
signal player_ready                                # internal: resumes the loop

@export var enemy_scene: PackedScene
@export var enemy_container: Node

@export_group("Waves")
@export var waves: Array[WaveData] = []

@export_group("Timing")
@export var initial_countdown: float = 5.0
@export var spawn_interval: float = 0.3
@export var post_wave_delay: float = 1.5    # lets death animations finish before the upgrade screen
@export var auto_start: bool = true

@onready var spawn_point: Marker2D = $SpawnPoint
@onready var goal_point: Marker2D = $GoalPoint

var current_wave: int = 0
var alive_enemies: int = 0
var is_running: bool = false
var is_waiting_for_player: bool = false

func _ready() -> void:
	if auto_start:
		start()

func start() -> void:
	if is_running:
		return

	assert(enemy_scene != null, "Spawner needs an enemy scene")
	assert(not waves.is_empty(), "Spawner needs at least one WaveData")
	is_running = true

	await _wait(initial_countdown)

	for i in waves.size():
		current_wave = i + 1
		await _run_wave(waves[i])

		# Pause between waves (but not after the last one)
		if current_wave < waves.size():
			await _wait(post_wave_delay)
			is_waiting_for_player = true
			waiting_for_player.emit(current_wave + 1)
			await player_ready

	is_running = false
	all_waves_completed.emit()

# Call this from the upgrade screen's "Next wave" button
func continue_to_next_wave() -> void:
	if not is_waiting_for_player:
		return
	is_waiting_for_player = false
	player_ready.emit()

func _run_wave(wave: WaveData) -> void:
	var total := wave.get_total_count()
	var spawned := 0
	wave_started.emit(current_wave, waves.size())

	for group in wave.groups:
		if group.enemy == null:
			continue
		for i in group.count:
			_spawn_enemy(group.enemy)
			spawned += 1
			if spawn_interval > 0.0 and spawned < total:
				await _wait(spawn_interval)

	# Everything is spawned; now wait until the last one is gone
	while alive_enemies > 0:
		await enemy_removed

	wave_cleared.emit(current_wave)

func _spawn_enemy(data: EnemyData) -> void:
	var enemy: Enemy = enemy_scene.instantiate()
	enemy.data = data
	enemy.goal_x = goal_point.global_position.x
	enemy.killed.connect(_on_enemy_gone)
	enemy.reached_goal.connect(_on_enemy_gone)
	alive_enemies += 1

	var parent: Node = enemy_container if enemy_container else self
	_add_enemy_deferred.call_deferred(parent, enemy)

func _add_enemy_deferred(parent: Node, enemy: Enemy) -> void:
	parent.add_child(enemy)
	enemy.global_position = spawn_point.global_position

func _on_enemy_gone(_enemy: Enemy) -> void:
	alive_enemies -= 1
	enemy_removed.emit()

func _wait(seconds: float) -> void:
	if seconds > 0.0:
		await get_tree().create_timer(seconds).timeout
