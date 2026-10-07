class_name MovementComponent
extends Node2D

signal reached_end

var base_speed: float = 0.0
var direction: Vector2 = Vector2.RIGHT
var end_x: float = INF
var is_active: bool = true

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var use_gravity: bool = true 

@onready var body: CharacterBody2D = get_parent()

func setup(speed: float, goal_x: float = INF) -> void:
	base_speed = speed
	end_x = goal_x
	is_active = true 

func _physics_process(delta: float) -> void:
	if use_gravity and not body.is_on_floor():
		body.velocity.y += gravity * delta
	
	if is_active:
		body.velocity.x = direction.x * base_speed * delta
	else:
		body.velocity.x = 0.0
	body.move_and_slide()
	
	if is_active and body.position.x >= end_x:
		is_active = false
		reached_end.emit()

# Possible functions later on for pause can also link to some buttons 
func stop() -> void:
	is_active = false

func resume() -> void:
	is_active = true 
