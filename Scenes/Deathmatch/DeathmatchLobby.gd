extends Control

const DEATHMATCH = preload("res://Scenes/Deathmatch/Deathmatch.tscn")

@onready var start_button: Button = $StartButton

var question: Question

func init(question: Question) -> void:
	self.question = question

func _ready() -> void:
	if is_multiplayer_authority():
		start_button.visible = true

@rpc("authority", "call_local", "reliable")
func start_game():
	Utils.remove_all_children(self)	
	var game = DEATHMATCH.instantiate()
	add_child(game)

func _on_start_button_pressed() -> void:
	start_game.rpc()	
