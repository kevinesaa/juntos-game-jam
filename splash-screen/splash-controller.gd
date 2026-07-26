extends Node


@onready var change_scene_controller: ChangeSceneController = $changeSceneController
@onready var to_main_timer: Timer = $toMainTimer
@onready var progress_bar: ProgressBar = $CanvasLayer/HBoxContainer/ProgressBar

func _ready() -> void:
	to_main_timer.start()
	
func start_next_scene_load():
	change_scene_controller.load_next_scene()

func on_next_scene_is_ready_listener():
	change_scene_controller.change_scene() 

func _update_progress_listener(value:float) -> void:
	progress_bar.value = value
	pass
