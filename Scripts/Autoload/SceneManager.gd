extends Node

var quiz_container: Node

signal start_quiz
var game_started := false

func _ready() -> void:
	if get_node("/root/main/quiz_container"):
		quiz_container = get_node("/root/main/quiz_container")

@rpc("authority", "call_remote", "reliable")
func load_scene(scene_path: String) -> void:
	if quiz_container:
		Utils.remove_all_children(quiz_container)
		var scene = load(scene_path)
		quiz_container.add_child(scene.instantiate())

@rpc("authority", "call_local", "reliable")
func set_game_started(state: bool) -> void:
	game_started = state

@rpc("any_peer", "call_remote", "reliable")
func get_game_started() -> void:
	set_game_started.rpc_id(multiplayer.get_remote_sender_id(), game_started)

func return_to_main_menu() -> void:
	multiplayer.multiplayer_peer = null 
	SceneManager.load_scene("res://Scenes/MainMenu/MainMenu.tscn")
	UserManager.user_list.clear()
