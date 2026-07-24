class_name ChangeSceneController
extends Node


var is_loading_next_scene:bool = false
var is_next_scene_ready:bool = false

@export var debug_loading:bool = false
func debug_loading_print()->void:
	if(debug_loading):
		print(str("current progress loading scene: ",self.progress_loading_scene))


@export var progress_steps_speed:float = 0.2
@export var path_to_next_scene:String


var progress_loading_scene:float = 0.0
signal progressing_loading_scene_updated(new_value:float)
signal progressing_loading_scene_completed() 



func _process(delta_time: float) -> void:
	
	if(!is_loading_next_scene):
		return
	debug_loading_print()
	if(self.progress_loading_scene < 1.0):
		var value_before_update:float = self.progress_loading_scene
		loading_status_update(delta_time)
		if(value_before_update != self.progress_loading_scene):
			self.progressing_loading_scene_updated.emit(self.progress_loading_scene)
			return
	
	if( !self.is_next_scene_ready && self.progress_loading_scene >= 1.0):
		self.is_next_scene_ready = true
		self.is_loading_next_scene = false
		self.progressing_loading_scene_completed.emit()
	

func load_next_scene() -> void:
	if(!is_loading_next_scene ):
		progress_loading_scene = 0
		is_loading_next_scene = true
		is_next_scene_ready = false
		load_package_scene()


func change_scene(parameters:Dictionary = {}) -> void:
	var resource = ResourceLoader.load_threaded_get(path_to_next_scene) as PackedScene
	var scene = resource.instantiate() as CustomScene
	scene.setParameters(parameters)
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(scene)
	get_tree().current_scene = scene
	
	
func load_package_scene() -> void:
	ResourceLoader.load_threaded_request(path_to_next_scene)

func loading_status_update(delta_time:float) -> void:
	
	var value_after_update:float = self.progress_loading_scene
	var progress_array:Array[float]
	var next_progress_value:float
	ResourceLoader.load_threaded_get_status(path_to_next_scene,progress_array)
	next_progress_value = progress_array[0]
	if(next_progress_value != self.progress_loading_scene):
		
		var current = lerp(self.progress_loading_scene,next_progress_value,delta_time)
		var factor:float = 0.5
		if (next_progress_value < 1.0 ):
			var diff:float = 0.9 - current
			factor = clamp(diff, 0.0, 1.0)
		
		var value = factor * delta_time * self.progress_steps_speed 
		value_after_update = current + value
	
	self.progress_loading_scene = clamp(value_after_update, 0.0, 1.0)
	
	
