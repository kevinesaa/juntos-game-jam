class_name BandSlideshow
extends VBoxContainer

@export var auto_advance_seconds: float = 6.0
@export var members: Array[Dictionary] = [
	{"name": "Manuel Van Der Dijs alias: VDD", "bio": "Cantante", "color": Color(0.75, 0.15, 0.15), "photo": preload("res://art-visuals/RealPhotos/manuel.png")},
	{"name": "Gabriel Gómez alias: Scorpio", "bio": "Guitarrista", "color": Color(0.15, 0.55, 0.25), "photo": preload("res://art-visuals/RealPhotos/Gabriel.png")},
	{"name": "Xander Hernández alias: Enigma", "bio": "Bajista", "color": Color(0.2, 0.3, 0.7), "photo": preload("res://art-visuals/RealPhotos/xander.png")},
	{"name": "Abraham Foucault alias: Shield Guard", "bio": "Baterista", "color": Color(0.6, 0.5, 0.1), "photo": preload("res://art-visuals/RealPhotos/abraham.png")},
]

@onready var photo_placeholder: ColorRect = $PhotoCenterContainer/photo_ColorRect
@onready var photo_texture_rect: TextureRect = $PhotoCenterContainer/photo_TextureRect
@onready var name_label: Label = $name_Label
@onready var bio_label: Label = $bio_Label
@onready var prev_button: Button = $NavHBoxContainer/prev_Button
@onready var next_button: Button = $NavHBoxContainer/next_Button
@onready var auto_advance_timer: Timer = $AutoAdvanceTimer

var current_index: int = 0

func _ready() -> void:
	auto_advance_timer.wait_time = auto_advance_seconds
	_render_current()

func _on_prev_button_pressed() -> void:
	_go_to((current_index - 1 + members.size()) % members.size())

func _on_next_button_pressed() -> void:
	_go_to((current_index + 1) % members.size())

func _on_auto_advance_timer_timeout() -> void:
	_go_to((current_index + 1) % members.size())

func _go_to(index: int) -> void:
	current_index = index
	_render_current()
	auto_advance_timer.start()

func _render_current() -> void:
	var entry: Dictionary = members[current_index]
	name_label.text = entry.get("name", "")
	bio_label.text = entry.get("bio", "")
	var texture: Texture2D = entry.get("photo", null)
	if texture:
		photo_texture_rect.texture = texture
		photo_texture_rect.visible = true
		photo_placeholder.visible = false
	else:
		photo_placeholder.color = entry.get("color", Color.GRAY)
		photo_placeholder.visible = true
		photo_texture_rect.visible = false
