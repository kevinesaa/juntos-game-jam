class_name LevelJamController
extends CustomScene


@onready var scene_controller_node: ChangeSceneController = $sceneController_Node
@onready var loading_progress_bar: ProgressBar = $CanvasLayer/loadingPanel/CenterContainer/VBoxContainer/ProgressBar
@onready var pause_panel: Panel = $CanvasLayer/pause_Panel
@onready var loading_panel: Panel = $CanvasLayer/loadingPanel
@onready var endgame_container_panel_container: PanelContainer = $CanvasLayer/endgame_container_PanelContainer

@onready var player_one_layout: CharacterUiController = $CanvasLayer/MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/PlayerOneLayout
@onready var player_two_layout: CharacterUiController = $CanvasLayer/MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/PlayerTwoLayout
@onready var player_three_layout: CharacterUiController = $CanvasLayer/MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/PlayerThreeLayout
@onready var player_four_layout: CharacterUiController = $CanvasLayer/MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/PlayerFourLayout

var statusPause:bool = false
var playerLayouts : Array[CharacterUiController]  = []

func  _ready() -> void:
	pause_panel.visible = false
	loading_panel.visible = false
	endgame_container_panel_container.visible = false
	self.playerLayouts.append(player_one_layout)
	self.playerLayouts.append(player_two_layout)
	self.playerLayouts.append(player_three_layout)
	self.playerLayouts.append(player_four_layout)
	
func on_toggle_pause_listener(statusPause:bool) -> void:
	pause_panel.visible = statusPause

func on_exit_game_click_listener() -> void:
	loading_panel.visible = true
	pause_panel.visible = false
	endgame_container_panel_container.visible = false
	scene_controller_node.load_next_scene()

func on_load_scene_complete_listener() -> void:
	scene_controller_node.change_scene()

func on_change_scene_controller_progressing_loading_scene_updated_listener(new_value: float) -> void:
	loading_progress_bar.value = new_value

func on_update_skill_recovery_status_listener(characterIndexId:int, skillIndex:int, value:float) -> void:
	
	var characterLayout = self.playerLayouts.get(characterIndexId)
	characterLayout.update_coldDown_status(skillIndex,value)

func on_end_game_listener() -> void:
	endgame_container_panel_container.visible = true
	
