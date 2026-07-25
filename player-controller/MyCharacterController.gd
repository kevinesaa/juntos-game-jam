class_name MyCharacterController
extends Node2D


@export var baseSpeed:float
@export var skills_node_paths:Array[String]


var indexId:int
var newPosition:Vector2 = Vector2.ZERO
var currentSkillIndex:int = 0
var charaterSkills: Array[SkillController] = []

func setIndexId(id:int) -> void:
	self.indexId = id

func moveCharacter(deltaTime:float,moveVector:Vector2) -> void:
	
	self.newPosition = (deltaTime * self.baseSpeed) * moveVector
	var position:Vector2 = self.position + self.newPosition
	self.position = position

func selectNextSkill() -> void:
	pass
	
func selectPreviusSkill() -> void:
	pass
