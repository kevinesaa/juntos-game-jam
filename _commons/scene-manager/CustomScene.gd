class_name CustomScene extends Node

var parameters:Dictionary = {}

func setParameters(parameters:Dictionary):
	self.parameters = parameters


func setupParameters() -> void:
	
	print("setupParameters")
	

func _ready() -> void:
	setupParameters()
