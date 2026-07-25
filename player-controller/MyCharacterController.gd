class_name MyCharacterController
extends Node2D


@export var baseSpeed:float
var newPosition:Vector2

func moveCharacter(deltaTime:float,moveVector:Vector2) -> void:
	self.newPosition = (deltaTime * self.baseSpeed) * moveVector
	self.position = self.position + self.newPosition
