class_name DebrisSpawner
extends Node2D

@export var debrisScene: PackedScene
@export var spawnIntervalMin: float = 1.0
@export var spawnIntervalMax: float = 2.5
@export var arenaMinX: float = 120.0
@export var arenaMaxX: float = 1160.0
@export var spawnY: float = -40.0
@export var landingY: float = 520.0

signal debris_destroyed(scoreValue: int)
signal debris_landed(x: float, damage: float)

var _timeToNextSpawn: float = 0.0

func _ready() -> void:
	_scheduleNextSpawn()

func _process(delta: float) -> void:
	_timeToNextSpawn -= delta
	if _timeToNextSpawn <= 0.0:
		_spawnDebris()
		_scheduleNextSpawn()

func _scheduleNextSpawn() -> void:
	_timeToNextSpawn = randf_range(spawnIntervalMin, spawnIntervalMax)

func _spawnDebris() -> void:
	var debris:FallingDebris = debrisScene.instantiate()
	debris.landingY = landingY
	add_child(debris)
	debris.global_position = Vector2(randf_range(arenaMinX, arenaMaxX), spawnY)
	debris.destroyed.connect(func(scoreValue): debris_destroyed.emit(scoreValue))
	debris.landed.connect(func(x, damage): debris_landed.emit(x, damage))
