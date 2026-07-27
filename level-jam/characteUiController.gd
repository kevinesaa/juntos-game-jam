class_name CharacterUiController
extends Node


@export var nameText:String
@export var imgPath:String
@onready var name_label: Label = $VBoxContainer/nameLabel
@onready var helth_progress_bar: ProgressBar = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/helth_ProgressBar
@onready var power_progress_bar: ProgressBar = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/power_ProgressBar

@onready var selection_highlight: ReferenceRect = $VBoxContainer/HBoxContainer/portrait_TextureRect/selectionHighlight
@onready var portrait_texture_rect: TextureRect = $VBoxContainer/HBoxContainer/portrait_TextureRect

@onready var skill_1_v_scroll_bar: VScrollBar = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/skills_one_CenterContainer/PanelContainer/VScrollBar
@onready var skill_2_v_scroll_bar: VScrollBar = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/skills_two_CenterContainer/PanelContainer/VScrollBar
@onready var skill_3_v_scroll_bar: VScrollBar = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/skills_three_CenterContainer/PanelContainer/VScrollBar

@onready var skill_1_selection_highlight: ReferenceRect = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/skills_one_CenterContainer/PanelContainer/skillSelectionHighlight
@onready var skill_2_selection_highlight: ReferenceRect = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/skills_two_CenterContainer/PanelContainer/skillSelectionHighlight
@onready var skill_3_selection_highlight: ReferenceRect = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/skills_three_CenterContainer/PanelContainer/skillSelectionHighlight

var skill_charge : Array[VScrollBar]
var skill_selection_highlights : Array[ReferenceRect]

func _ready() -> void:
	name_label.text = nameText
	var tempPreload = load(imgPath)
	self.portrait_texture_rect.texture =  tempPreload 
	skill_charge.append(skill_1_v_scroll_bar)
	skill_charge.append(skill_2_v_scroll_bar)
	skill_charge.append(skill_3_v_scroll_bar)
	skill_selection_highlights.append(skill_1_selection_highlight)
	skill_selection_highlights.append(skill_2_selection_highlight)
	skill_selection_highlights.append(skill_3_selection_highlight)


func setSkillMaxValue(skillIndexId:int, value:float) -> void:
	var progress = skill_charge.get(skillIndexId)
	progress.max_value =value
	

func update_coldDown_status(skillIndexId:int, value:float) -> void:
	var progress = skill_charge.get(skillIndexId)
	progress.value = value

func update_health(value:float) -> void:
	helth_progress_bar.value = value

func update_power(value:float) -> void:
	power_progress_bar.value = value

func set_selected(isSelected:bool) -> void:
	selection_highlight.visible = isSelected

func set_selected_skill(skillIndexId:int) -> void:
	for i in skill_selection_highlights.size():
		skill_selection_highlights.get(i).visible = (i == skillIndexId)
