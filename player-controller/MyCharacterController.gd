class_name MyCharacterController
extends Node2D

@export var baseHealth:float
@export var baseSpeed:float
@export var skills_node_paths:Array[NodePath] =[]

#region skill controller signals
signal on_current_skill_change(characterIndexId:int, skillIndex:int)
signal on_character_health_change(currentHealth:float)
signal on_skill_execute_notify(characterIndexId:int, skillIndex:int)
#endregion

var currentHealth:float
var characterIndexId:int
var newPosition:Vector2 = Vector2.ZERO
var currentSkillIndex:int = 0
var charaterSkills: Array[SkillController] = []

func _ready() -> void:
	
	for i in skills_node_paths.size():
		var path = skills_node_paths.get(i)
		var skillNode = get_node_or_null(path)
		var skill = skillNode as SkillController
		skill.setSkillIndexId(i)
		skill.setCharacterOwnIndexId(characterIndexId)
		charaterSkills.append(skill)
	
func _process(delta: float) -> void:
	pass


func setCharacterIndexId(id:int) -> void:
	self.characterIndexId = id
	if(charaterSkills != null):
		for skill in charaterSkills:
			skill.setCharacterOwnIndexId(id)
		

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


func executeSkill() -> void:
	
	var currentSkill:SkillController = charaterSkills.get(self.currentSkillIndex)
	currentSkill.executeSkill()
