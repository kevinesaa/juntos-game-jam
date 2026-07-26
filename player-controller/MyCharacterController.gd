class_name MyCharacterController
extends Node2D

@export var baseHealth:float = 100.0
@export var baseSpeed:float
@export var skills_node_paths:Array[NodePath] =[]
@export var path_animation_controller:NodePath

#region skill controller signals
signal on_current_skill_change(characterIndexId:int, skillIndex:int)
signal on_character_health_change(characterIndexId:int, currentHealth:float)
signal on_skill_execute_notify(characterIndexId:int, skillIndex:int)
signal on_recovery_skill_status(characterIndexId:int, skillIndex:int, value:float)
signal on_debris_destroyed_by_character(characterIndexId:int)
#endregion

var currentHealth:float
var characterIndexId:int
var newPosition:Vector2 = Vector2.ZERO
var currentSkillIndex:int = 0
var charaterSkills: Array[SkillController] = []
var animationController:AnimatedSprite2D
var speedMultiplier:float = 1.0


func _ready() -> void:
	self.currentHealth = self.baseHealth
	animationController = get_node_or_null(path_animation_controller) as AnimatedSprite2D
	for i in skills_node_paths.size():
		var path = skills_node_paths.get(i)
		var skillNode = get_node_or_null(path)
		var skill = skillNode as SkillController
		skill.setSkillIndexId(i)
		skill.setCharacterOwnIndexId(characterIndexId)
		skill.recovery_skill_status.connect(_update_skill_status_listener)
		skill.debris_destroyed_by_character.connect(_on_debris_destroyed_by_character_listener)
		charaterSkills.append(skill)

func _process(delta: float) -> void:
	pass


func setCharacterIndexId(id:int) -> void:
	self.characterIndexId = id
	if(charaterSkills != null):
		for skill in charaterSkills:
			skill.setCharacterOwnIndexId(id)


func moveCharacter(deltaTime:float,moveVector:Vector2) -> void:

	self.newPosition = (deltaTime * self.baseSpeed * self.speedMultiplier) * moveVector
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

func _update_skill_status_listener(characterIndexId:int, skillIndex:int, value:float) -> void:
	self.on_recovery_skill_status.emit(characterIndexId,skillIndex,value)

func _on_debris_destroyed_by_character_listener(characterIndexId:int) -> void:
	self.on_debris_destroyed_by_character.emit(characterIndexId)

func takeDamage(amount:float) -> void:
	self.currentHealth = max(self.currentHealth - amount, 0.0)
	on_character_health_change.emit(self.characterIndexId, self.currentHealth)
