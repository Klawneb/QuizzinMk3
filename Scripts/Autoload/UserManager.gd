extends Node

var user_list: Array[User] = []

signal user_list_updated

@rpc("any_peer", "call_remote", "reliable")
func add_user(multiplayer_id: int, username: String) -> void:
	var user = User.new(multiplayer_id, username)
	user_list.append(user)
	user_list_updated.emit()
	
	if is_multiplayer_authority():
		add_user.rpc(multiplayer_id, username)

@rpc("any_peer", "call_remote", "reliable")
func get_existing_users(multiplayer_id: int):
	for user in user_list:
		add_user.rpc_id(multiplayer_id, user.multiplayer_id, user.username)

func remove_user(multiplayer_id: int):
	for user in user_list:
		if user.multiplayer_id == multiplayer_id:
			user_list.erase(user)
	user_list_updated.emit()
