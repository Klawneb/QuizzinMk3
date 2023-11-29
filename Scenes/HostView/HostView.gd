extends Control

@onready var question_list: VBoxContainer = %QuestionList

func _ready() -> void:
	QuestionManager.question_list_updated.connect(load_questions)

	load_questions()	

func _on_reveal_answer_button_pressed() -> void:
	QuestionManager.emit_reveal_answer.rpc()

func load_questions():
	Utils.remove_all_children(question_list)
	
	for question in QuestionManager.question_list:	
		var question_list_item = load("res://Scenes/HostView/QuestionListItem/QuestionListItem.tscn").instantiate()
		question_list_item.init(question)
		question_list.add_child(question_list_item)
