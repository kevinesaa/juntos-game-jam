class_name RangedShotSkill
extends SkillController

@export var skillRange: float = 400.0

@onready var shotLine: Line2D = $ShotLine
@onready var impact_vfx: CPUParticles2D = $ImpactVfx

func skillEffect() -> void:
	var anchor := get_parent() as Node2D
	if anchor == null:
		return
	var target := _find_nearest_debris(anchor.global_position)
	if target == null:
		return
	_flashShot(anchor, target)
	_playImpactVfx(target.global_position)
	target.destroy()
	debris_destroyed_by_character.emit(self.characterIndexId)

func _find_nearest_debris(origin: Vector2) -> Node2D:
	var nearest: Node2D = null
	var nearestDistSq: float = 0.0
	var rangeSq: float = self.skillRange * self.skillRange
	for node in get_tree().get_nodes_in_group("falling_debris"):
		var debris := node as Node2D
		if debris == null:
			continue
		var distSq: float = origin.distance_squared_to(debris.global_position)
		if distSq > rangeSq:
			continue
		if nearest == null or distSq < nearestDistSq:
			nearest = debris
			nearestDistSq = distSq
	return nearest

func _flashShot(anchor: Node2D, target: Node2D) -> void:
	shotLine.points = [shotLine.to_local(anchor.global_position), shotLine.to_local(target.global_position)]
	shotLine.visible = true
	await get_tree().create_timer(0.08).timeout
	shotLine.visible = false

func _playImpactVfx(at_position: Vector2) -> void:
	impact_vfx.global_position = at_position
	impact_vfx.restart()
