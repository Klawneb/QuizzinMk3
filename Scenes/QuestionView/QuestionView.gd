extends Control

@onready var question_container: BoxContainer = %QuestionContainer
@onready var answer_container: BoxContainer = %AnswerContainer

var QuestionScenes = {
	Question.QuestionType.TEXT: "res://Scenes/QuestionView/QuestionText/QuestionText.tscn"
}

var AnswerScenes = {
	Question.AnswerType.TEXT: "res://Scenes/QuestionView/AnswerText/AnswerText.tscn"
}

func _ready() -> void:
	QuestionManager.question_load.connect(on_question_load)
	
func on_question_load(question: Question) -> void:
	Utils.remove_all_children(question_container)
	Utils.remove_all_children(answer_container)	
	
	if question.question_type != Question.QuestionType.NONE:
		var question_node = load(QuestionScenes[question.question_type]).instantiate()
		question_node.init(question)
		question_container.add_child(question_node)
	
	if question.answer_type != Question.AnswerType.NONE:
		var answer_node = load(AnswerScenes[question.answer_type]).instantiate()
		answer_node.init(question)
		answer_container.add_child(answer_node)
