extends Control

@onready var username_input: LineEdit = $PanelContainer/MarginContainer/VBoxContainer/UsernameInput
@onready var ip_address_input: LineEdit = $PanelContainer/MarginContainer/VBoxContainer/IpAddressInput


func _on_host_button_pressed() -> void:
	NetworkManager.create_server(username_input.text)

func _on_join_button_pressed() -> void:
	NetworkManager.create_client(username_input.text, ip_address_input.text)
