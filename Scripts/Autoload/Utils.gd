extends Node

func remove_all_children(node: Node):
	for child in node.get_children():
		child.queue_free()
