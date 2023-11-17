extends Node

@onready var personal_id: String = load_user_id()

func remove_all_children(node: Node) -> void:
	for child in node.get_children():
		child.queue_free()

func load_user_id() -> String:
	# For get a random non stored id for testing purposes
	if OS.is_debug_build():
		return uuid.v4()
	
	if not FileAccess.file_exists("user://user_id.txt"):
		create_user_id()
	
	var id_file = FileAccess.open("user://user_id.txt", FileAccess.READ)
	return id_file.get_as_text()

func create_user_id() -> void:
	var file = FileAccess.open("user://user_id.txt", FileAccess.WRITE)
	var id = uuid.v4()
	file.store_line(id)
