extends Control

@onready var user_answers: VBoxContainer = $UserAnswers

func _ready() -> void:
	UserManager.user_list_updated.connect(update_answer_list)
	AnswerManager.answers_updated.connect(update_answer_list)
	QuestionManager.current_question_updated.connect(update_answer_list)
	
	update_answer_list()

func update_answer_list() -> void:
	Utils.remove_all_children(user_answers)
	for user_id in UserManager.user_list.keys():
		var user = UserManager.user_list[user_id]
		var user_answer_item = load("res://Scenes/HostView/UserAnswerItem/UserAnswerItem.tscn").instantiate()
		if QuestionManager.current_question:
			user_answer_item.init(user.username, AnswerManager.get_answer(QuestionManager.current_question.id, user_id), AnswerManager.get_answer_score(QuestionManager.current_question.id, user_id))
			user_answers.add_child(user_answer_item)
