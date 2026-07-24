class_name MainMenuController
extends CustomScene

@onready var loading_panel: Panel = $CanvasLayer/loadingPanel
@onready var change_scene_controller: ChangeSceneController = $ChangeSceneController
@onready var loading_progress_bar: ProgressBar = $CanvasLayer/loadingPanel/CenterContainer/VBoxContainer/loadingProgressBar

func _ready() -> void:
	loading_panel.visible = false

func on_click_play_button_listener() -> void:
	loading_progress_bar.value = 0
	loading_panel.visible = true
	change_scene_controller.load_next_scene()
	

func on_play_scene_ready() -> void:
	change_scene_controller.change_scene()


func on_change_scene_controller_progressing_loading_scene_updated_listener(new_value: float) -> void:
	loading_progress_bar.value = new_value
