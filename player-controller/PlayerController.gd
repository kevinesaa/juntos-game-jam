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
#endregion

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
		
	
func  _process(delta: float) -> void:
	
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
		
	_move(delta,moveInput)
	
	

func _physics_process(delta: float) -> void:
	
	pass
	
func  _previusCharater() -> void:
	self.currentSelectedIndex = self.currentSelectedIndex - 1
	if(self.currentSelectedIndex < 0):
		self.currentSelectedIndex = self.characters.size() - 1
	
	on_current_character_change.emit(self.currentSelectedIndex)		
	
func _nextCharacter() -> void:
	self.currentSelectedIndex = self.currentSelectedIndex + 1
	var maxIndex:int = characters.size() - 1
	if(self.currentSelectedIndex > maxIndex):
		self.currentSelectedIndex = 0
	
	on_current_character_change.emit(self.currentSelectedIndex)
	
	
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
