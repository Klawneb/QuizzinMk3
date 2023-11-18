extends Resource
class_name Question

enum QuestionType {
	TEXT,
	IMAGE,
	NONE
}

enum AnswerType {
	TEXT,
	NONE
}

@export var id: String
@export var main_text: String
@export var answer: String

@export var question_type: QuestionType
@export var answer_type: AnswerType
