extends Node

const PLAYER = preload("res://Scenes/Deathmatch/player.tscn")
@onready var players: Node3D = $Players
@onready var spawnpoints: Array = $Spawnpoints.get_children()

var question: Question

func init(question: Question) -> void:
	self.question = question

func _enter_tree() -> void:
	$MultiplayerSpawner.spawn_function = spawn_player
	
func _exit_tree() -> void:
	SceneManager.background_visibility_changed.emit(true)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneManager.player_died.connect(respawn)
	SceneManager.background_visibility_changed.emit(false)
	SceneManager.add_player_debug.connect(func(): $MultiplayerSpawner.spawn({
					"multiplayer_id": randi(), 
					"spawn_position": get_spawnpoints().pick_random().position
					}))
	
	if is_multiplayer_authority():
		for user in UserManager.user_list.values():
			if user.connected:
				var spawn_position = get_spawnpoints().pick_random().position
				$MultiplayerSpawner.spawn({
					"multiplayer_id": user.multiplayer_id,
					"username": user.username,
					"spawn_position": spawn_position
					})
			
			await get_tree().create_timer(0.01).timeout

func spawn_player(data):
	var player = PLAYER.instantiate()
	player.name = str(data.multiplayer_id)
	player.username = data.username
	player.position = data.spawn_position
	return player

func get_spawnpoints() -> Array:
	var available = []
	for point in spawnpoints:
		if point.empty:
			available.append(point)
	return available

func respawn():
	SceneManager.respawn_player.emit(get_spawnpoints().pick_random().position)
