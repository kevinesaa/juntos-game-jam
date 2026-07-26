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
@onready var together_label: Label = $CanvasLayer/MarginContainer/VBoxContainer/togetherHBoxContainer/togetherLabel
@onready var together_progress_bar: ProgressBar = $CanvasLayer/MarginContainer/VBoxContainer/togetherHBoxContainer/together_ProgressBar

@onready var player_one_layout: CharacterUiController = $CanvasLayer/MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/PlayerOneLayout
@onready var player_two_layout: CharacterUiController = $CanvasLayer/MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/PlayerTwoLayout
@onready var player_three_layout: CharacterUiController = $CanvasLayer/MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/PlayerThreeLayout
@onready var player_four_layout: CharacterUiController = $CanvasLayer/MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/PlayerFourLayout

const LANE_HALF_WIDTH := 90.0
## Matches the ProgressBar's default max_value, same reasoning as baseColdDown.
const POWER_MAX := 100.0

## Charge added to a character's own power meter per debris *they personally*
## destroy. At 25.0 it takes 4 kills per character (16 total) to unlock
## JUNTOS, vs. 10 kills shared previously — tune here, the bars follow
## automatically. Playtest this number first if JUNTOS feels too rare/frequent.
@export var powerPerKill:float = 25.0

var statusPause:bool = false
var score:int = 0
var characterPower : Array[float] = [0.0, 0.0, 0.0, 0.0]
var playerLayouts : Array[CharacterUiController]  = []

func  _ready() -> void:
	pause_panel.visible = false
	loading_panel.visible = false
	endgame_container_panel_container.visible = false
	self.playerLayouts.append(player_one_layout)
	self.playerLayouts.append(player_two_layout)
	self.playerLayouts.append(player_three_layout)
	self.playerLayouts.append(player_four_layout)
	_updateTogetherBar()
	# PlayerController starts on index 0 but only emits on_current_character_change
	# when the selection *changes*, so seed the highlight here or nothing is
	# highlighted until the player first presses Q/E.
	_highlightSelectedCharacter(0)
	# Same reasoning as above, but for skill selection instead of character
	# selection: on_selected_skill_change_notify only fires on change.
	for layout in self.playerLayouts:
		layout.set_selected_skill(0)

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

func on_debris_destroyed_by_character_listener(characterIndexId:int) -> void:
	self.characterPower[characterIndexId] = min(self.characterPower[characterIndexId] + self.powerPerKill, POWER_MAX)
	self.playerLayouts.get(characterIndexId).update_power(self.characterPower[characterIndexId])
	_updateTogetherBar()

func _allCharactersFull() -> bool:
	for power in self.characterPower:
		if power < POWER_MAX:
			return false
	return true

func on_together_skill_requested_listener() -> void:
	if not _allCharactersFull():
		return
	for debris in get_tree().get_nodes_in_group("falling_debris"):
		if debris.has_method("destroy"):
			debris.destroy()
	# This mass-clear calls destroy() directly, bypassing the skill layer, so
	# it never re-emits debris_destroyed_by_character and cannot refill
	# characterPower — resetting here is safe and final, not a race.
	for i in self.characterPower.size():
		self.characterPower[i] = 0.0
	_updateTogetherBar()

func _updateTogetherBar() -> void:
	var total := 0.0
	for power in self.characterPower:
		total += power
	together_progress_bar.max_value = POWER_MAX * self.characterPower.size()
	together_progress_bar.value = total
	if _allCharactersFull():
		together_label.text = "JUNTOS! [SPACE]"
	else:
		together_label.text = "JUNTOS"

func on_current_character_change_listener(characterIndexId:int) -> void:
	_highlightSelectedCharacter(characterIndexId)

func on_selected_skill_change_notify_listener(characterIndexId:int, skillIndexId:int) -> void:
	self.playerLayouts.get(characterIndexId).set_selected_skill(skillIndexId)

func _highlightSelectedCharacter(selectedIndex:int) -> void:
	for i in self.playerLayouts.size():
		self.playerLayouts.get(i).set_selected(i == selectedIndex)

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
	var camera := get_tree().get_first_node_in_group("main_camera") as CameraShake
	if camera != null:
		camera.addTrauma(0.3)

func on_end_game_listener() -> void:
	debris_spawner_node.set_process(false)
	endgame_result_label.text = "You survived the earthquake! Score: %d" % self.score
	endgame_container_panel_container.visible = true
