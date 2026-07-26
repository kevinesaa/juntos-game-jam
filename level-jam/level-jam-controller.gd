class_name LevelJamController
extends CustomScene


@onready var scene_controller_node: ChangeSceneController = $sceneController_Node
@onready var loading_progress_bar: ProgressBar = $CanvasLayer/loadingPanel/CenterContainer/VBoxContainer/ProgressBar
@onready var pause_panel: Panel = $CanvasLayer/pause_Panel
@onready var loading_panel: Panel = $CanvasLayer/loadingPanel
@onready var endgame_container_panel_container: PanelContainer = $CanvasLayer/endgame_container_PanelContainer
@onready var endgame_result_label: Label = $CanvasLayer/endgame_container_PanelContainer/VBoxContainer/CenterContainer/resultLabel

@onready var player_controller_node: PlayerController = $gameNode/playerController_Node
@onready var debris_spawner_node: DebrisSpawner = $gameNode/debrisSpawner_Node
@onready var score_label: Label = $CanvasLayer/MarginContainer/VBoxContainer/scoreLabel

@onready var player_one_layout: CharacterUiController = $CanvasLayer/MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/PlayerOneLayout
@onready var player_two_layout: CharacterUiController = $CanvasLayer/MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/PlayerTwoLayout
@onready var player_three_layout: CharacterUiController = $CanvasLayer/MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/PlayerThreeLayout
@onready var player_four_layout: CharacterUiController = $CanvasLayer/MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/PlayerFourLayout

const LANE_HALF_WIDTH := 90.0

var statusPause:bool = false
var score:int = 0
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

func on_character_health_change_listener(characterIndexId:int, value:float) -> void:
	self.playerLayouts.get(characterIndexId).update_health(value)

func on_debris_destroyed_listener(scoreValue:int) -> void:
	self.score += scoreValue
	score_label.text = "Score: %d" % self.score

func on_debris_landed_listener(x:float, damage:float) -> void:
	var nearestCharacter:MyCharacterController = null
	var nearestDist:float = INF
	for character in player_controller_node.characters:
		var dist = abs(character.global_position.x - x)
		if dist < nearestDist:
			nearestDist = dist
			nearestCharacter = character
	if nearestCharacter != null and nearestDist <= LANE_HALF_WIDTH:
		nearestCharacter.takeDamage(damage)

func on_end_game_listener() -> void:
	debris_spawner_node.set_process(false)
	endgame_result_label.text = "You survived the earthquake! Score: %d" % self.score
	endgame_container_panel_container.visible = true
