extends Node

const PORT: int = 6969

var username: String

func _ready() -> void:
	multiplayer.connected_to_server.connect(on_connected_to_server)
	multiplayer.server_disconnected.connect(on_server_disconnected)
	multiplayer.peer_disconnected.connect(on_peer_disconnected)
	
func create_server(username: String) -> void:
	self.username = username
	var peer = ENetMultiplayerPeer.new()
	var err: Error = peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	
	if err == OK:
		SceneManager.load_scene("res://Scenes/Lobby/Lobby.tscn")
		UserManager.add_user(1, username)
	
func create_client(username: String, ip_address: String) -> void:
	self.username = username
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip_address, PORT)
	multiplayer.multiplayer_peer = peer

# Runs on clients when they connect to the server
func on_connected_to_server() -> void:
	SceneManager.load_scene("res://Scenes/Lobby/Lobby.tscn")
	UserManager.get_existing_users.rpc_id(1, multiplayer.get_unique_id())
	UserManager.add_user.rpc_id(1, multiplayer.get_unique_id(), self.username)

# Runs on clients when they lose connection to the server
func on_server_disconnected() -> void:
	SceneManager.load_scene("res://Scenes/MainMenu/MainMenu.tscn")
	UserManager.user_list.clear()
	OS.alert("Server Disconnected")

# Runs on all clients when a client disconnects
func on_peer_disconnected(multiplayer_id: int):
	UserManager.remove_user(multiplayer_id)
