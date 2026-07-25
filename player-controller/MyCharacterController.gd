class_name MyCharacterController
extends Node2D


@export var baseSpeed:float
@export var skills_node_paths:Array[NodePath] =[]

#region skill controller signals
signal on_current_skill_change(characterIndexId:int, skillIndex:int)
#endregion
var characterIndexId:int
var newPosition:Vector2 = Vector2.ZERO
var currentSkillIndex:int = 0
var charaterSkills: Array[SkillController] = []

func _ready() -> void:
	
	for path in skills_node_paths:
		var skillNode = get_node_or_null(path)
		var skill = skillNode as SkillController
		charaterSkills.append(skill)
	

func setCharacterIndexId(id:int) -> void:
	self.characterIndexId = id

func moveCharacter(deltaTime:float,moveVector:Vector2) -> void:
	
	self.newPosition = (deltaTime * self.baseSpeed) * moveVector
	var position:Vector2 = self.position + self.newPosition
	self.position = position

func selectPreviusSkill() -> void:
	
	self.currentSkillIndex = self.currentSkillIndex - 1
	if(self.currentSkillIndex < 0):
		self.currentSkillIndex = self.charaterSkills.size() - 1
	
	on_current_skill_change.emit(self.characterIndexId,self.currentSkillIndex)
	
func selectNextSkill() -> void:
	
	self.currentSkillIndex = self.currentSkillIndex + 1
	var maxIndex:int = charaterSkills.size() - 1
	if(self.currentSkillIndex > maxIndex):
		self.currentSkillIndex = 0
	
	on_current_skill_change.emit(self.characterIndexId,self.currentSkillIndex)
