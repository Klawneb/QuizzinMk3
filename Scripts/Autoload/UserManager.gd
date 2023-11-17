extends Node

var user_list: Dictionary = {}

signal user_list_updated

@rpc("any_peer", "call_remote", "reliable")
func add_user(personal_id: String, multiplayer_id: int, username: String) -> void:
	if user_list.has(personal_id):
		var user = user_list[personal_id]
		user.username = username
		user.multiplayer_id = multiplayer_id
		user.connected = true
	else:
		user_list[personal_id] = {
			"username": username,
			"multiplayer_id": multiplayer_id,
			"score": 0,
			"connected": true
		}
	
	user_list_updated.emit()
	if is_multiplayer_authority():
		add_user.rpc(personal_id, multiplayer_id, username)

@rpc("any_peer", "call_remote", "reliable")
func get_existing_users(multiplayer_id: int) -> void:
	for personal_id in user_list.keys():
		var user = user_list[personal_id]
		add_user.rpc_id(multiplayer_id, personal_id, user.multiplayer_id, user.username)

func remove_user(multiplayer_id: int) -> void:
	for personal_id in user_list.keys():
		var user = user_list[personal_id]
		if user.multiplayer_id == multiplayer_id:
			user.connected = false
	user_list_updated.emit()
