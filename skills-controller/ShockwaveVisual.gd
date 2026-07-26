class_name ShockwaveVisual
extends Node2D

@export var ringColor: Color = Color(1, 0.6, 0.1, 0.9)
@export var ringWidth: float = 3.0

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var parentSkill := get_parent() as SkillController
	if parentSkill == null or parentSkill.baseTimeSkillEffect <= 0.0:
		return
	var progress: float = clamp(parentSkill.currentTimeSkillEffect / parentSkill.baseTimeSkillEffect, 0.0, 1.0)
	var currentRadius: float = parentSkill.shockwave_radius * progress
	var color := ringColor
	color.a = ringColor.a * (1.0 - progress)
	draw_arc(Vector2.ZERO, currentRadius, 0, TAU, 48, color, ringWidth)
