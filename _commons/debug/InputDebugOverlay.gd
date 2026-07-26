class_name InputDebugOverlay
extends Label

const TRACKED_ACTIONS := [
	"previus_character", "next_character",
	"move_left", "move_right",
	"previus_skill", "next_skill",
	"use_skill", "basic_attack",
	"together_skill", "upgrade_skill",
	"follow_me", "unfollow_me",
	"pause",
]

func _ready() -> void:
	visible = OS.is_debug_build()

func _process(_delta: float) -> void:
	var lines := PackedStringArray()
	for action in TRACKED_ACTIONS:
		lines.append(("[x] " if Input.is_action_pressed(action) else "[ ] ") + action)
	text = "\n".join(lines)
