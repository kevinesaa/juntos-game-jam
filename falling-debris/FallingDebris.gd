class_name FallingDebris
extends Node2D

@export var fallSpeed: float = 80.0
@export var damage: float = 10.0
@export var scoreValue: int = 10

var landingY: float = 260.0

signal destroyed(scoreValue: int)
signal landed(x: float, damage: float)

func _ready() -> void:
	add_to_group("falling_debris")

func _process(delta: float) -> void:
	global_position.y += fallSpeed * delta
	if global_position.y >= landingY:
		landed.emit(global_position.x, damage)
		queue_free()

func destroy() -> void:
	destroyed.emit(scoreValue)
	queue_free()
