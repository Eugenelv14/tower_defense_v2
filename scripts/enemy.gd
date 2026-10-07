class_name Enemy
extends CharacterBody2D

signal reached_goal(enemy: Enemy)
signal killed(enemy: Enemy)
@export var data: EnemyData

@onready var body_shape: CollisionShape2D = $CollisionShape2D
@onready var hurtbox_shape: CollisionShape2D = $Hitbox/CollisionShape2D

@onready var movement: MovementComponent = $MovementComponent
@onready var health: HealthComponent = $HealthComponent
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


#The x coordinate will be set up by the spawner scene
var goal_x: float = INF 

func _ready() -> void:
	assert(data != null, "Enemy needs an EnemyData resource")
	
	# Link Sprites frames
	sprite.sprite_frames = data.sprite_frames
	sprite.scale = data.sprite_scale
	sprite.play("move")
	apply_collision()
	
	health.setup(data.max_health)
	movement.setup(data.speed, goal_x)

func apply_collision() -> void:
	var body := RectangleShape2D.new()
	body.size = data.body_size
	body_shape.shape = body
	body_shape.position = data.body_offset

	var hurt := RectangleShape2D.new()
	hurt.size = data.hurtbox_size
	hurtbox_shape.shape = hurt
	hurtbox_shape.position = data.hurtbox_offset

func _on_health_component_died() -> void:
	"Enemy was killed"
	movement.stop()
	set_deferred("collision_layer",0)
	hurtbox_shape.set_deferred("monitoring", false)
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
