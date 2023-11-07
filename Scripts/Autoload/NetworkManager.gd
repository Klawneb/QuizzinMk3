extends Node

const PORT = 6969
var username = ""

func create_server(username: String) -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	
func create_client(username: String, ip_address: String) -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip_address, PORT)
	multiplayer.multiplayer_peer = peer
