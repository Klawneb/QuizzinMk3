extends Control

var music_bus_index = AudioServer.get_bus_index("Music")
var sfx_bus_index = AudioServer.get_bus_index("Sound Effects")
@onready var music_volume_label: Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MusicVolumeLabel
@onready var sfx_volume_label: Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/SFXVolumeLabel
@onready var wokeness_label: Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer3/WokenessLabel

@onready var music_slider: HSlider = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MusicSlider
@onready var sfx_slider: HSlider = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/SFXSlider
@onready var wokeness_slider: HSlider = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer3/WokenessSlider
@onready var lgbt: Panel = $PanelContainer/LGBT

func _ready() -> void:
	music_volume_label.text = str(music_slider.value)
	sfx_volume_label.text = str(sfx_slider.value)
	wokeness_label.text = str(wokeness_slider.value)
	SceneManager.settings_opened.connect(show_settings)
	SceneManager.settings_closed.connect(hide_settings)

func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus_index, lerp(-30, 5, value/100))
	music_volume_label.text = str(value)

func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfx_bus_index, lerp(-30, 5, value/100))
	sfx_volume_label.text = str(value)

func _on_wokeness_slider_value_changed(value: float) -> void:
	wokeness_label.text = str(value)
	lgbt.self_modulate = Color(1,1,1, lerp(0., 0.025, value/10))
	UserManager.wokeness = value
	UserManager.wokeness_updated.emit()

func _on_back_button_pressed() -> void:
	hide_settings()

func show_settings():
	self.visible = true

func hide_settings():
	self.visible = false
