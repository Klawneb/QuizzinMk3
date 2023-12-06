extends Control

@onready var username_input: LineEdit = $PanelContainer/MarginContainer/VBoxContainer/UsernameInput
@onready var ip_address_input: LineEdit = $PanelContainer/MarginContainer/VBoxContainer/IpAddressInput
@onready var pronoun_selector: OptionButton = $PanelContainer/MarginContainer/VBoxContainer/PronounSelector

func _ready() -> void:
	UserManager.wokeness_updated.connect(wokeify)

func _on_host_button_pressed() -> void:
	NetworkManager.create_server(username_input.text)

func _on_join_button_pressed() -> void:
	NetworkManager.create_client(username_input.text, ip_address_input.text)

func _on_settings_button_pressed() -> void:
	SceneManager.settings_opened.emit()

func wokeify():
	if UserManager.wokeness > 5:
		pronoun_selector.visible = true
	else:
		pronoun_selector.visible = false
