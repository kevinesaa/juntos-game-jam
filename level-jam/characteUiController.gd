class_name CharacterUiController
extends Node


@export var nameText:String
@onready var name_label: Label = $VBoxContainer/nameLabel
@onready var helth_progress_bar: ProgressBar = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/helth_ProgressBar
@onready var power_progress_bar: ProgressBar = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/power_ProgressBar

@onready var skill_1_v_scroll_bar: VScrollBar = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/skills_one_CenterContainer/PanelContainer/VScrollBar
@onready var skill_2_v_scroll_bar: VScrollBar = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/skills_two_CenterContainer/PanelContainer/VScrollBar
@onready var skill_3_v_scroll_bar: VScrollBar = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/skills_three_CenterContainer/PanelContainer/VScrollBar

var skill_charge : Array[VScrollBar]

func _ready() -> void:
	name_label.text = nameText
	skill_charge.append(skill_1_v_scroll_bar)
	skill_charge.append(skill_2_v_scroll_bar)
	skill_charge.append(skill_3_v_scroll_bar) 
	

func setSkillMaxValue(skillIndexId:int, value:float) -> void:
	var progress = skill_charge.get(skillIndexId)
	progress.max_value =value
	

func update_coldDown_status(skillIndexId:int, value:float) -> void:
	var progress = skill_charge.get(skillIndexId)
	progress.value = value
