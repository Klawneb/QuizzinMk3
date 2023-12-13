extends Node

const PLAYER = preload("res://Scenes/Deathmatch/player.tscn")
@onready var players: Node3D = $Players
@onready var spawnpoints: Array = $Spawnpoints.get_children()

var question: Question

func init(question: Question) -> void:
	self.question = question
	
func _exit_tree() -> void:
	SceneManager.background_visibility_changed.emit(true)	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneManager.background_visibility_changed.emit(false)
	
	for user in UserManager.user_list.values():
		if user.connected:
			add_player(user.multiplayer_id)

func add_player(multiplayer_id: int) -> void:
	var player = PLAYER.instantiate()
	player.name = str(multiplayer_id)
	player.position = spawnpoints.pick_random().position
	players.add_child(player)
