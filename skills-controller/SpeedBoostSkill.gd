class_name SpeedBoostSkill
extends SkillController

@export var boostSpeedMultiplier: float = 2.0
@export var boostDuration: float = 3.0
@export var path_boost_visual_node: NodePath

@onready var boost_visual_node: Node2D = get_node_or_null(path_boost_visual_node) as Node2D

var _boostedCharacter: MyCharacterController
var _boostTimeRemaining: float = 0.0
var _isBoosting: bool = false

func _ready() -> void:
	super._ready()

func skillEffect() -> void:
	var character := get_parent() as MyCharacterController
	if character == null:
		return
	_boostedCharacter = character
	_boostedCharacter.speedMultiplier = self.boostSpeedMultiplier
	_boostTimeRemaining = self.boostDuration
	_isBoosting = true
	if boost_visual_node != null:
		boost_visual_node.visible = true

func _process(delta: float) -> void:
	super._process(delta)
	if not _isBoosting:
		return
	_boostTimeRemaining -= delta
	if _boostTimeRemaining <= 0.0:
		_boostedCharacter.speedMultiplier = 1.0
		_isBoosting = false
		if boost_visual_node != null:
			boost_visual_node.visible = false
