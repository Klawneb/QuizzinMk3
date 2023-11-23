extends Control

@onready var question_list: VBoxContainer = $TabContainer/QuestionView/HBoxContainer/HostSidePanel/QuestionList

func _ready() -> void:
	for question in QuestionManager.question_list:
		var question_list_item = load("res://Scenes/HostView/QuestionListItem/QuestionListItem.tscn").instantiate()
		question_list_item.init(question)
		question_list.add_child(question_list_item)

func _on_reveal_answer_button_pressed() -> void:
	QuestionManager.emit_reveal_answer.rpc()
