class_name SkillController
extends Node

@export var recoverySpeed:float
@export var baseColdDown:float
var currentColdDownStatus:float

#region skills signals
signal execute_without_power()
signal execute_skill(characterIndexId:int,skillIndexId:int)
signal recovery_skill_status(characterIndexId:int,skillIndexId:int,curentValue:float)
#endregion
var characterIndexId:int = 0
var skillIndexId:int = 0

func skillEffect()-> void:
	pass

func setCharacterOwnIndexId(characterIndex:int) -> void:
	self.characterIndexId = characterIndex
	

func setSkillIndexId(skillId:int):
	self.skillIndexId = skillId

func canExecute() -> bool:
	return self.currentColdDownStatus >= self.baseColdDown
	
func executeSkill() -> void:
	
	if(canExecute()):
		execute_without_power.emit()
	else:
		self.skillEffect()
		self.execute_skill.emit(self.characterIndexId,self.skillIndexId)
		self.currentColdDownStatus = 0
		self.recovery_skill_status.emit(self.characterIndexId,self.skillIndexId,currentColdDownStatus)

func  _ready() -> void:
	self.currentColdDownStatus = self.baseColdDown

func _process(delta: float) -> void:
	
	if(self.currentColdDownStatus < self.baseColdDown):
		var recovery = delta * recoverySpeed
		self.currentColdDownStatus = self.currentColdDownStatus + recovery
		self.recovery_skill_status.emit(self.characterIndexId,self.skillIndexId,currentColdDownStatus)
	
