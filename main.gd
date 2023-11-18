extends Node

@onready var debug_menu: Window = $DebugMenu
@onready var user_list: RichTextLabel = $DebugMenu/TabContainer/UserList
@onready var answer_list: RichTextLabel = $DebugMenu/TabContainer/AnswerList

func _ready() -> void:
	UserManager.user_list_updated.connect(update_user_list)
	AnswerManager.answers_updated.connect(update_answer_list)
	update_user_list()
	update_answer_list()

func _on_debug_button_pressed() -> void:
	debug_menu.visible = !debug_menu.visible

func update_user_list():
	user_list.text = var_to_str(UserManager.user_list)

func update_answer_list():
	answer_list.text = var_to_str(AnswerManager.answers)
