extends ProgressBar

@export var health: HealthComponent
@export var visible_time: float = 2.0   # seconds on screen after a hit
@export var fade_time: float = 0.4

var tween: Tween

func _ready() -> void:
	modulate.a = 0.0                      # hidden at the start
	health.health_changed.connect(_on_health_changed)
	health.damaged.connect(_on_damaged)
	health.died.connect(_on_died)

func _on_health_changed(current: int, maximum: int) -> void:
	max_value = maximum                   # set max before value
	value = current

func _on_damaged(_amount: int) -> void:
	if tween:
		tween.kill()                      # restart the timer if hit again
	modulate.a = 1.0
	tween = create_tween()
	tween.tween_interval(visible_time)
	tween.tween_property(self, "modulate:a", 0.0, fade_time)

func _on_died() -> void:
	if tween:
		tween.kill()
	modulate.a = 0.0
