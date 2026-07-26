class_name PlayerController
extends Node

@onready var player_1_node_2d: MyCharacterController = $player1_Node2D
@onready var player_2_node_2d: MyCharacterController = $player2_Node2D
@onready var player_3_node_2d: MyCharacterController = $player3_Node2D
@onready var player_4_node_2d: MyCharacterController = $player4_Node2D

signal on_press_pause_notify(pauseStatus:bool)

#region player signal
signal on_current_character_change(indexId:int)
signal on_selected_skill_change_notify(characterIndexId:int, skillIndexId:int)
signal on_recovery_skill_status(characterIndexId:int, skillIndex:int, value:float)
signal on_character_health_change_notify(characterIndexId:int, value:float)
signal on_together_skill_requested()
signal on_debris_destroyed_by_character_notify(characterIndexId:int)
#endregion

var endGame:bool = false
var pauseStatus:bool = false
var characters:Array[MyCharacterController] = []
var currentSelectedIndex:int = 0


func _ready() -> void:
	characters.append(player_1_node_2d)
	characters.append(player_2_node_2d)
	characters.append(player_3_node_2d)
	characters.append(player_4_node_2d)
	
	for i in characters.size():
		var c = characters.get(i)
		c.setCharacterIndexId(i)
		c.on_current_skill_change.connect(self._selectedSkillChangeListener)
		c.on_recovery_skill_status.connect(self._update_skill_status_listener)
		c.on_character_health_change.connect(self._characterHealthChangeListener)
		c.on_debris_destroyed_by_character.connect(self._debrisDestroyedByCharacterListener)
	_updateSelectedCharacterOutline()
	
func  _process(delta: float) -> void:
	
	if(endGame):
		return
	
	var pauseButtonPress = Input.is_action_just_pressed("pause")
	if(pauseButtonPress):
		self.pauseStatus = not self.pauseStatus
		self.on_press_pause_notify.emit(self.pauseStatus)
	
	if(pauseStatus):
		return 
	
	var previusCharacter = Input.is_action_just_pressed("previus_character")
	var nextCharacter = Input.is_action_just_pressed("next_character")
	
	if(previusCharacter):
		_previusCharater()
	if(nextCharacter):
		_nextCharacter()
	
	var previusSkill = Input.is_action_just_pressed("previus_skill")
	var nextSkill = Input.is_action_just_pressed("next_skill")
	var moveInput:float = Input.get_axis("move_left","move_right")
	
	if(previusSkill):
		self._previusSkill()
	
	if(nextSkill):
		self._nextSkill()
	
	var togetherSkill = Input.is_action_just_pressed("together_skill")
	var upgradeCurrentSkill = Input.is_action_just_pressed("upgrade_skill")
	
	
	var specialSkill = Input.is_action_just_pressed("use_skill")
	var basicSkill = Input.is_action_just_pressed("basic_attack")
	
	var followme = Input.is_action_just_pressed("follow_me")
	var unfollowme = Input.is_action_just_pressed("unfollow_me")
	
	if(togetherSkill):
		self.on_together_skill_requested.emit()

	if(specialSkill):
		_skill_one()
	
	_move(delta,moveInput)
	
	

func _physics_process(delta: float) -> void:
	
	pass
	
func  _previusCharater() -> void:
	self.currentSelectedIndex = self.currentSelectedIndex - 1
	if(self.currentSelectedIndex < 0):
		self.currentSelectedIndex = self.characters.size() - 1

	on_current_character_change.emit(self.currentSelectedIndex)
	_updateSelectedCharacterOutline()

func _nextCharacter() -> void:
	self.currentSelectedIndex = self.currentSelectedIndex + 1
	var maxIndex:int = characters.size() - 1
	if(self.currentSelectedIndex > maxIndex):
		self.currentSelectedIndex = 0

	on_current_character_change.emit(self.currentSelectedIndex)
	_updateSelectedCharacterOutline()

func _updateSelectedCharacterOutline() -> void:
	for i in self.characters.size():
		self.characters.get(i).setSelected(i == self.currentSelectedIndex)

	
func _move(deltaTime:float, moveInput:float) -> void:
	var currentCharacter:MyCharacterController = self.characters.get(self.currentSelectedIndex)
	var moveVector:Vector2 = moveInput * Vector2.RIGHT
	currentCharacter.moveCharacter(deltaTime,moveVector)
	
func _previusSkill() -> void:
	var currentCharacter:MyCharacterController = self.characters.get(self.currentSelectedIndex)
	currentCharacter.selectPreviusSkill()
	
func _nextSkill() -> void:
	var currentCharacter:MyCharacterController = self.characters.get(self.currentSelectedIndex)
	currentCharacter.selectNextSkill()
	
func _selectedSkillChangeListener(characterIndexId:int, skillIndexId:int) -> void:
	
	self.on_selected_skill_change_notify.emit(characterIndexId,skillIndexId)

func _skill_one() -> void:
	var currentCharacter:MyCharacterController = self.characters.get(self.currentSelectedIndex)
	currentCharacter.executeSkill()

func _update_skill_status_listener(characterIndexId:int, skillIndex:int, value:float) -> void:
	
	self.on_recovery_skill_status.emit(characterIndexId,skillIndex,value)
	
func on_end_game_listener() -> void:
	endGame = true

func _characterHealthChangeListener(characterIndexId:int, value:float) -> void:
	self.on_character_health_change_notify.emit(characterIndexId, value)

func _debrisDestroyedByCharacterListener(characterIndexId:int) -> void:
	self.on_debris_destroyed_by_character_notify.emit(characterIndexId)
