extends Node

func _ready() -> void:
	install_sounds(get_parent())

func install_sounds(node: Node) -> void:
	for i in node.get_children():
		if i is Button:
			i.mouse_entered.connect(func(): ui_sfx_play(&"UI_Hover"))
			i.pressed.connect(func(): ui_sfx_play(&"UI_Click"))
		install_sounds(i)

func ui_sfx_play(sound: StringName) -> void:
	SoundManager.sounds[sound].play()
