extends StaticBody2D

@export var max_health: int = 50
@onready var health: HealthComponent = $HealthComponent

var attackers: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health.setup(max_health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	for enemy in attackers.keys():
		
		#check if enemy has been deleted and if so update dict
		if not is_instance_valid(enemy):
			attackers.erase(enemy)
			continue

		attackers[enemy] -= delta
		if attackers[enemy] <= 0.0:
			enemy.sprite.play("attack")
			enemy.movement.stop()
			health.take_damage(enemy.data.attack_damage)
			print("Your tower is taking damage!")
			print("Health Remaining: ", health.current_health)
			attackers[enemy] = enemy.data.attack_interval

func _on_health_component_died() -> void:
	"Tower has been destroyed"
	for enemy in attackers.keys():
		enemy.sprite.play("move")
		enemy.movement.resume()
	queue_free()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Enemy:
		attackers[body] = 0.0

func _on_hitbox_body_exited(body: Node2D) -> void:
	attackers.erase(body)
