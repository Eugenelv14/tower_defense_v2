class_name EnemyData
extends Resource
# attack die idle move take_hit

@export var sprite_frames: SpriteFrames
@export var sprite_scale: Vector2 = Vector2.ONE

@export var max_health: int
@export var attack_damage: int 
@export var attack_interval: float
@export var coins_dropped: int
@export var speed: int 

@export_group("Collision")
@export var body_size: Vector2 = Vector2(32, 32)
@export var body_offset: Vector2 = Vector2.ZERO
@export var hurtbox_size: Vector2 = Vector2(32, 32)
@export var hurtbox_offset: Vector2 = Vector2.ZERO
