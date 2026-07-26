class_name ShockwaveRadiusDebug
extends Node2D

@export var debugColor: Color = Color(1, 0.3, 0.3, 0.6)

func _ready() -> void:
	visible = OS.is_debug_build()

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var parentSkill := get_parent() as SkillController
	if parentSkill == null:
		return
	draw_arc(Vector2.ZERO, parentSkill.shockwave_radius, 0, TAU, 48, debugColor, 2.0)
