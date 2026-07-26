class_name CharacterUiController
extends Node

@export var nameText:String
@onready var name_label: Label = $VBoxContainer/nameLabel

func _ready() -> void:
	name_label.text = nameText
	pass
