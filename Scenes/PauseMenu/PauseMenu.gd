extends Control

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("open_menu"):
		self.visible = !self.visible
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
		
		if !self.visible:
			Input.mouse_mode = SceneManager.global_mouse_mode
			SceneManager.settings_closed.emit()

func _on_quit_button_pressed() -> void:
	SceneManager.return_to_main_menu()

func _on_close_button_pressed() -> void:
	self.visible = false

func _on_settings_button_pressed() -> void:
	SceneManager.settings_opened.emit()
