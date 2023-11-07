extends Node

var quiz_container: Node

func _ready() -> void:
	if get_node("/root/main/quiz_container"):
		quiz_container = get_node("/root/main/quiz_container")

func load_scene(scene_path: String) -> void:
	if quiz_container:
		Utils.remove_all_children(quiz_container)
		var scene: Node = load(scene_path).instantiate()
		quiz_container.add_child(scene)
