class_name CameraShake
extends Camera2D

@export var maxOffset: float = 8.0
@export var traumaDecayPerSecond: float = 2.0

var trauma: float = 0.0

func _ready() -> void:
	add_to_group("main_camera")

func addTrauma(amount: float) -> void:
	trauma = clamp(trauma + amount, 0.0, 1.0)

func _process(delta: float) -> void:
	if trauma <= 0.0:
		offset = Vector2.ZERO
		return
	trauma = max(trauma - traumaDecayPerSecond * delta, 0.0)
	var shake := trauma * trauma
	offset = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * maxOffset * shake
