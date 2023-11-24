extends Resource
class_name Question

enum QuestionType {
	TEXT,
	IMAGE,
	AUDIO,
	NONE
}

enum AnswerType {
	TEXT,
	NONE
}

@export var id: String
@export var main_text: String
@export var answers: Array[String]

@export var question_type: QuestionType
@export var answer_type: AnswerType
