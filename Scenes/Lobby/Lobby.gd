extends Control

@onready var user_list: ItemList = $PanelContainer/MarginContainer/VBoxContainer/UserList
@onready var start_button: Button = $PanelContainer/MarginContainer/VBoxContainer/StartButton

func _ready() -> void:
	UserManager.user_list_updated.connect(update_user_list)
	start_button.visible = is_multiplayer_authority()

func _on_quit_button_pressed() -> void:
	multiplayer.multiplayer_peer = null
	SceneManager.load_scene("res://Scenes/MainMenu/MainMenu.tscn")
	UserManager.user_list.clear()

func update_user_list() -> void:
	user_list.clear()
	for id in UserManager.user_list:
		var user = UserManager.user_list[id]
		if user.connected:
			user_list.add_item(user.username)

func _on_start_button_pressed() -> void:
	SceneManager.load_scene("res://Scenes/HostView/HostView.tscn")
	SceneManager.load_scene.rpc("res://Scenes/QuestionView/QuestionView.tscn")
