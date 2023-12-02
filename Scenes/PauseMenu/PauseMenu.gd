extends Control

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("open_menu"):
		self.visible = !self.visible

func _on_quit_button_pressed() -> void:
	SceneManager.return_to_main_menu()

func _on_close_button_pressed() -> void:
	self.visible = false
