extends Node


@onready var change_scene_controller: ChangeSceneController = $changeSceneController
@onready var to_main_timer: Timer = $toMainTimer

func _ready() -> void:
	to_main_timer.start()
	
func start_next_scene_load():
	change_scene_controller.load_next_scene()

func on_next_scene_is_ready_listener():
	change_scene_controller.change_scene() 
