extends Control

@onready var user_list: ItemList = $PanelContainer/MarginContainer/VBoxContainer/UserList
@onready var start_button: Button = $PanelContainer/MarginContainer/VBoxContainer/StartButton

func _ready() -> void:
	UserManager.user_list_updated.connect(update_user_list)
	start_button.visible = is_multiplayer_authority()

func _on_quit_button_pressed() -> void:
	SceneManager.return_to_main_menu()

func update_user_list() -> void:
	user_list.clear()
	for id in UserManager.user_list:
		var user = UserManager.user_list[id]
		if user.connected:
			user_list.add_item(user.username)

func _on_start_button_pressed() -> void:
	SceneManager.set_game_started.rpc(true)
	SceneManager.load_host_view.rpc()
