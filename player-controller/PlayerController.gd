class_name PlayerController
extends Node

@onready var player_1_node_2d: MyCharacterController = $player1_Node2D
@onready var player_2_node_2d: MyCharacterController = $player2_Node2D
@onready var player_3_node_2d: MyCharacterController = $player3_Node2D
@onready var player_4_node_2d: MyCharacterController = $player4_Node2D

var characters:Array[MyCharacterController] = []
var currentSelectedIndex:int = 0




func _ready() -> void:
	characters.append(player_1_node_2d)
	characters.append(player_2_node_2d)
	characters.append(player_3_node_2d)
	characters.append(player_4_node_2d)



	
	
func  _process(delta: float) -> void:
	
	var previusCharacter = Input.is_action_just_pressed("previus_character")
	var nextCharacter = Input.is_action_just_pressed("next_character")
	
	if(previusCharacter):
		_previusCharater()
	if(nextCharacter):
		_nextCharacter()
	
	
	var moveInput:float = Input.get_axis("move_left","move_right")
	
	_move(delta,moveInput)
		

func _physics_process(delta: float) -> void:
	
	pass
	
func  _previusCharater() -> void:
	self.currentSelectedIndex = self.currentSelectedIndex - 1
	if(self.currentSelectedIndex < 0):
		self.currentSelectedIndex = self.characters.size() - 1
		
func _nextCharacter() -> void:
	self.currentSelectedIndex = self.currentSelectedIndex + 1
	var maxIndex:int = characters.size() - 1
	if(self.currentSelectedIndex > maxIndex):
		self.currentSelectedIndex = 0
	
func _move(deltaTime:float, moveInput:float) -> void:
	var currentCharacter:MyCharacterController = self.characters.get(self.currentSelectedIndex)
	var moveVector:Vector2 = moveInput*Vector2.RIGHT
	currentCharacter.moveCharacter(deltaTime,moveVector)
	
	
	
