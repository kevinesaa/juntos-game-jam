class_name MainMenuController
extends CustomScene

@onready var loading_panel: Panel = $CanvasLayer/loadingPanel
@onready var change_scene_controller: ChangeSceneController = $ChangeSceneController
@onready var loading_progress_bar: ProgressBar = $CanvasLayer/loadingPanel/CenterContainer/VBoxContainer/loadingProgressBar

@onready var panel_container: PanelContainer = $CanvasLayer/MarginContainer/HBoxContainer/PanelContainer

# Referencias a los contenidos del panel lateral (crea estos nodos hijos dentro de tu PanelContainer)
@onready var about_content: Control = $CanvasLayer/MarginContainer/HBoxContainer/PanelContainer/about_Content
@onready var support_content: Control = $CanvasLayer/MarginContainer/HBoxContainer/PanelContainer/support_Content
@onready var controls_content: Control = $CanvasLayer/MarginContainer/HBoxContainer/PanelContainer/controls_Content
@onready var settings_content: Control = $CanvasLayer/MarginContainer/HBoxContainer/PanelContainer/settings_Content
@onready var credits_content: Control = $CanvasLayer/MarginContainer/HBoxContainer/PanelContainer/credits_Content

func _ready() -> void:
	#loading_panel.visible.bind(false) # Oculto al iniciar
	loading_panel.visible = false
	_hide_all_contents()

func _hide_all_contents() -> void:
	if about_content: about_content.visible = false
	if support_content: support_content.visible = false
	if controls_content: controls_content.visible = false
	if settings_content: settings_content.visible = false
	if credits_content: credits_content.visible = false

func _toggle_content(target_content: Control) -> void:
	var is_currently_visible = target_content.visible
	_hide_all_contents()
	target_content.visible = not is_currently_visible

# --- BOTÓN PLAY (Recuperado y adaptado a tu señal original) ---

func on_click_play_button_listener() -> void:
	loading_progress_bar.value = 0
	loading_panel.visible = true
	change_scene_controller.load_next_scene()

func on_play_scene_ready() -> void:
	change_scene_controller.change_scene()

func on_change_scene_controller_progressing_loading_scene_updated_listener(new_value: float) -> void:
	loading_progress_bar.value = new_value

# --- BOTÓN QUIT ---

func on_exit_click_listener() -> void:
	get_tree().quit()

# --- LISTENERS DEL PANEL LATERAL ---

func _on_about_button_pressed() -> void:
	_toggle_content(about_content)

func _on_support_button_pressed() -> void:
	_toggle_content(support_content)

func _on_controls_button_pressed() -> void:
	_toggle_content(controls_content)

func _on_settings_button_pressed() -> void:
	_toggle_content(settings_content)

func _on_credits_button_pressed() -> void:
	_toggle_content(credits_content)
