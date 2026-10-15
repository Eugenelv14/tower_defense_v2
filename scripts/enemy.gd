class_name Enemy
extends CharacterBody2D

signal reached_goal(enemy: Enemy)
signal killed(enemy: Enemy)
@export var data: EnemyData
@onready var hitbox: Area2D = $Hitbox

@onready var body_shape: CollisionShape2D = $CollisionShape2D
@onready var hurtbox_shape: CollisionShape2D = $Hitbox/CollisionShape2D

@onready var movement: MovementComponent = $MovementComponent
@onready var health: HealthComponent = $HealthComponent
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


#The x coordinate will be set up by the spawner scene
var goal_x: float = INF 

func _ready() -> void:
	assert(data != null, "Enemy needs an EnemyData resource")

	sprite.sprite_frames = data.sprite_frames
	sprite.scale = data.sprite_scale
	_align_sprite()
	sprite.play("move")
	apply_collision()

	health.setup(data.max_health)
	movement.setup(data.speed, goal_x)
	
func _align_sprite() -> void:
	# Put the bottom edge of the frame on the origin (the feet), then apply the nudge
	var frame := data.sprite_frames.get_frame_texture("move", 0)
	var height := frame.get_size().y * data.sprite_scale.y
	sprite.position = Vector2(0, -height / 2.0) + data.sprite_offset
	
func apply_collision() -> void:
	var body := RectangleShape2D.new()
	body.size = data.body_size
	body_shape.shape = body
	# Bottom edge of the shape sits on the origin
	body_shape.position = Vector2(0, -data.body_size.y / 2.0) + data.body_offset

	var hurt := RectangleShape2D.new()
	hurt.size = data.hurtbox_size
	hurtbox_shape.shape = hurt
	hurtbox_shape.position = Vector2(0, -data.hurtbox_size.y / 2.0) + data.hurtbox_offset

func _on_health_component_died() -> void:
	print("Enemy was killed")
	movement.stop()
	set_deferred("collision_layer",0)
	hitbox.set_deferred("monitoring", false)
	hurtbox_shape.set_deferred("disabled", true)
	killed.emit(self)
	sprite.play("die")
	await sprite.animation_finished
	queue_free()

func _on_movement_component_reached_end() -> void:
	reached_goal.emit(self)
	print("The monsters destroyed your tower you lose!")
	queue_free()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if not "arrow_damage" in area:
		return
	health.take_damage(area.arrow_damage)
	area.queue_free()
