class_name LevelJamController
extends CustomScene


@onready var scene_controller_node: ChangeSceneController = $sceneController_Node
@onready var loading_progress_bar: ProgressBar = $CanvasLayer/loadingPanel/CenterContainer/VBoxContainer/ProgressBar
@onready var pause_panel: Panel = $CanvasLayer/pause_Panel
@onready var loading_panel: Panel = $CanvasLayer/loadingPanel

var statusPause:bool = false

func  _ready() -> void:
	pause_panel.visible = false
	loading_panel.visible = false
	
func on_toggle_pause_listener(statusPause:bool) -> void:
	pause_panel.visible = statusPause

func on_exit_game_click_listener() -> void:
	loading_panel.visible = true
	pause_panel.visible = false
	scene_controller_node.load_next_scene()

func on_load_scene_complete_listener() -> void:
	scene_controller_node.change_scene()

func on_change_scene_controller_progressing_loading_scene_updated_listener(new_value: float) -> void:
	loading_progress_bar.value = new_value
