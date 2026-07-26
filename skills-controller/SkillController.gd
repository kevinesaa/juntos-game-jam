class_name SkillController
extends Node
@export var recoverySpeed:float
@export var baseColdDown:float
@export var baseTimeSkillEffect:float
@export var SpeedSkillEffectTime:float
@export var path_shock_wave_node_2d: NodePath
@export var shockwave_radius: float = 110.0
var currentColdDownStatus:float
var currentTimeSkillEffect:float
var shock_wave_node_2d: Node2D

#region skills signals
signal execute_without_power()
signal execute_skill(characterIndexId:int,skillIndexId:int)
signal recovery_skill_status(characterIndexId:int,skillIndexId:int,curentValue:float)
signal debris_destroyed_by_character(characterIndexId:int)
#endregion
var characterIndexId:int = 0
var skillIndexId:int = 0

func skillEffect() -> void:
	if self.shock_wave_node_2d == null:
		return
	self.shock_wave_node_2d.visible = true
	self.currentTimeSkillEffect = 0.0
	_damage_debris_in_radius()
	var camera := get_tree().get_first_node_in_group("main_camera") as CameraShake
	if camera != null:
		camera.addTrauma(0.5)

func _damage_debris_in_radius() -> void:
	var origin:Vector2 = self.shock_wave_node_2d.global_position
	for debris in get_tree().get_nodes_in_group("falling_debris"):
		if not debris.has_method("destroy"):
			continue
		if debris.global_position.distance_to(origin) <= self.shockwave_radius:
			debris.destroy()
			debris_destroyed_by_character.emit(self.characterIndexId)

func setCharacterOwnIndexId(characterIndex:int) -> void:
	self.characterIndexId = characterIndex


func setSkillIndexId(skillId:int):
	self.skillIndexId = skillId

func isCanExecute() -> bool:
	return self.currentColdDownStatus >= self.baseColdDown

func executeSkill() -> void:

	if(not isCanExecute()):
		execute_without_power.emit()
	else:

		self.skillEffect()
		self.execute_skill.emit(self.characterIndexId,self.skillIndexId)
		self.currentColdDownStatus = 0
		self.recovery_skill_status.emit(self.characterIndexId,self.skillIndexId,currentColdDownStatus)


func  _ready() -> void:
	self.currentColdDownStatus = self.baseColdDown
	self.shock_wave_node_2d = get_node_or_null(path_shock_wave_node_2d) as Node2D
	self.currentTimeSkillEffect = self.baseTimeSkillEffect
	if self.shock_wave_node_2d != null:
		self.shock_wave_node_2d.visible = false

func _process(delta: float) -> void:

	if(self.currentColdDownStatus < self.baseColdDown):
		var recovery = delta * recoverySpeed
		self.currentColdDownStatus = self.currentColdDownStatus + recovery
		self.recovery_skill_status.emit(self.characterIndexId,self.skillIndexId,currentColdDownStatus)

	if self.shock_wave_node_2d != null and self.currentTimeSkillEffect < self.baseTimeSkillEffect:
		var temp = delta * SpeedSkillEffectTime
		self.currentTimeSkillEffect = self.currentTimeSkillEffect + temp
		if(self.currentTimeSkillEffect >= self.baseTimeSkillEffect):
			self.shock_wave_node_2d.visible = false
