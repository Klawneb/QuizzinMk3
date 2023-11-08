extends Node

var quiz_container: Node

signal start_quiz

func _ready() -> void:
	if get_node("/root/main/quiz_container"):
		quiz_container = get_node("/root/main/quiz_container")

@rpc("authority", "call_remote", "reliable")
func load_scene(scene_path: String) -> void:
	if quiz_container:
		Utils.remove_all_children(quiz_container)
		var scene = load(scene_path)
		quiz_container.add_child(scene.instantiate())
